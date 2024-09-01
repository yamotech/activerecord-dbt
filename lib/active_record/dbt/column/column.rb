# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Column
        include ActiveRecord::Dbt::DataType::Mapper
        include ActiveRecord::Dbt::I18nWrapper::Translate

        attr_reader :table_name, :column, :column_data_test, :primary_keys

        delegate :name, :comment, to: :column, prefix: true
        delegate :source_config, to: :@config

        def initialize(table_name, column, column_data_test, primary_keys: [])
          @table_name = table_name
          @column = column
          @column_data_test = column_data_test
          @primary_keys = primary_keys
          @config = ActiveRecord::Dbt::Config.instance
        end

        def properties
          {
            'name' => column_name,
            'description' => description,
            'data_type' => data_type(column.type),
            **column_overrides.except(:data_tests),
            'data_tests' => column_data_test.properties
          }.compact
        end

        private

        def description
          @description ||=
            column_description ||
            translated_attribute_name ||
            column_comment ||
            key_column_name ||
            default_column_description ||
            "Write a description of the '#{table_name}.#{column_name}' column."
        end

        def column_description
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

        def column_overrides
          @column_overrides ||=
            source_config.dig(:table_overrides, table_name, :columns, column_name) ||
            {}
        end
      end
    end
  end
end
