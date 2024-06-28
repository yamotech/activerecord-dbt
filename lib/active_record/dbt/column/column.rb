# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Column
        attr_reader :table_name, :column, :column_test, :primary_keys

        delegate :name, to: :column
        delegate :source_config, to: :@config

        def initialize(table_name, column, column_test, primary_keys: [])
          @table_name = table_name
          @column = column
          @column_test = column_test
          @primary_keys = primary_keys
          @config = ActiveRecord::Dbt::Config.instance
        end

        def config
          {
            'name' => name,
            'description' => description,
            **column_overrides.except(:tests),
            'tests' => column_test.config
          }.compact
        end

        private

        def description
          @description ||=
            column_description ||
            I18n.t("activerecord.attributes.#{table_name.singularize}.#{name}", default: nil) ||
            I18n.t("attributes.#{name}", default: nil) ||
            column.comment ||
            key_column_name ||
            default_column_description ||
            "Write a description of the '#{table_name}.#{name}' column."
        end

        def column_description
          source_config.dig(:table_descriptions, table_name, :columns, name)
        end

        def default_column_description
          source_config.dig(:defaults, :table_descriptions, :columns, :description)
                       &.gsub('#{table_name}', table_name)
                       &.gsub('#{column_name}', name)
        end

        def key_column_name
          name if primary_key? || foreign_key?
        end

        def primary_key?
          primary_keys.include?(name)
        end

        def foreign_key?
          ActiveRecord::Base.connection.foreign_key_exists?(table_name, column: name)
        end

        def column_overrides
          @column_overrides ||=
            source_config.dig(:table_overrides, table_name, :columns, name) ||
            {}
        end
      end
    end
  end
end
