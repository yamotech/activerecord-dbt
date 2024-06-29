# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Column
        attr_reader :table_name, :column, :column_test, :primary_keys

        delegate :name, :comment, to: :column, prefix: true
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
            'name' => column_name,
            'description' => description,
            **column_overrides.except(:tests),
            'tests' => column_test.config
          }.compact
        end

        private

        # rubocop:disable Metrics/CyclomaticComplexity
        def description
          @description ||=
            column_description ||
            translated_attribute_name ||
            translated_default_attribute_name ||
            column_comment ||
            key_column_name ||
            default_column_description ||
            "Write a description of the '#{table_name}.#{column_name}' column."
        end
        # rubocop:enable Metrics/CyclomaticComplexity

        def column_description
          source_config.dig(:table_descriptions, table_name, :columns, column_name)
        end

        def translated_attribute_name
          I18n.t("activerecord.attributes.#{table_name.singularize}.#{column_name}", default: nil)
        end

        def translated_default_attribute_name
          I18n.t("attributes.#{column_name}", default: nil)
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
                       &.gsub('#{table_name}', table_name)
                       &.gsub('#{column_name}', column_name)
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
