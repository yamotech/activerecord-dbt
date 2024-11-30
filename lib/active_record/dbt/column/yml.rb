# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Yml
        include ActiveRecord::Dbt::DataType::Mapper
        include ActiveRecord::Dbt::I18nWrapper::Translate
        include ActiveRecord::Dbt::Validation::TableNameValidator

        using ActiveRecord::Dbt::CoreExt::ActiveRecordExt

        attr_reader :table_name, :column, :column_data_test, :primary_keys

        # MEMO: GitHub copilot taught me this.
        SQL_KEYWORDS = %w[
          ADD ALL ALTER AND ANY AS ASC BACKUP BETWEEN CASE CHECK COLUMN CONSTRAINT CREATE
          DATABASE DEFAULT DELETE DESC DISTINCT DROP EXEC EXISTS FOREIGN FROM FULL GROUP
          HAVING IN INDEX INNER INSERT INTO IS JOIN LEFT LIKE LIMIT NOT NULL OR ORDER OUTER
          PRIMARY PROCEDURE RIGHT ROWNUM SELECT SET TABLE TOP TRUNCATE UNION UNIQUE UPDATE
          VALUES VIEW WHERE
        ].freeze

        delegate :name, :comment, to: :column, prefix: true
        delegate :source_config, to: :@config

        def initialize(table_name, column, column_data_test = Struct.new(:properties).new, primary_keys: [])
          @config = ActiveRecord::Dbt::Config.instance
          @table_name = validate_table_name(table_name, @config)
          @column = column
          @column_data_test = column_data_test
          @primary_keys = primary_keys
        end

        def properties
          {
            'name' => column_name,
            'description' => description,
            'quote' => quote?,
            'data_type' => data_type(column.type),
            **column_overrides.except(:data_tests),
            'data_tests' => column_data_test.properties
          }.compact
        end

        def column_description
          config_column_description ||
            translated_column_name ||
            column_comment ||
            key_column_name ||
            default_column_description
        end

        private

        def description
          @description ||=
            column_description ||
            "Write a description of the '#{table_name}.#{column_name}' column."
        end

        def config_column_description
          source_config.dig(:table_descriptions, table_name, :columns, column_name)
        end

        def key_column_name
          column_name if primary_key? || foreign_key?
        end

        def primary_key?
          primary_keys.include?(column_name)
        end

        def foreign_key?
          ActiveRecord::Base.connection.foreign_key_exists?(table_name, column: column_name)
        end

        def default_column_description
          source_config.dig(:defaults, :table_descriptions, :columns, :description)
                       &.gsub(/{{\s*table_name\s*}}/, table_name)
                       &.gsub(/{{\s*column_name\s*}}/, column_name)
        end

        # MEMO: [quote | dbt Developer Hub](https://docs.getdbt.com/reference/resource-properties/quote)
        def quote?
          true if SQL_KEYWORDS.include?(column_name.upcase)
        end

        def column_overrides
          @column_overrides ||=
            source_config.dig(:table_overrides, table_name, :columns, column_name) ||
            {}
        end
      end
    end
  end
end
