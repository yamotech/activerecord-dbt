# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      class Yml
        include ActiveRecord::Dbt::I18nWrapper::Translate
        include ActiveRecord::Dbt::Table::Base

        attr_reader :table_data_test, :columns

        delegate :project_name, :source_config, to: :@config

        def initialize(table_name, table_data_test = Struct.new(:properties).new, columns = [])
          super(table_name)
          @table_data_test = table_data_test
          @columns = columns
        end

        def properties
          {
            **table_properties,
            'columns' => columns.map(&:properties)
          }.compact
        end

        def logical_name
          config_logical_name ||
            translated_table_name ||
            default_logical_name
        end

        private

        def table_properties
          {
            'name' => table_name,
            'description' => description,
            **table_overrides.except(:columns),
            'data_tests' => table_data_test.properties
          }
        end

        def description
          return table_description_title if table_description.blank?

          [
            "# #{project_name} #{table_description_title}",
            table_description
          ].join("\n")
        end

        def table_description_title
          @table_description_title ||=
            logical_name ||
            "Write a logical_name of the '#{table_name}' table."
        end

        def config_logical_name
          source_config.dig(:table_descriptions, table_name, :logical_name)
        end

        def default_logical_name
          source_config.dig(:defaults, :table_descriptions, :logical_name)
                       &.gsub(/{{\s*table_name\s*}}/, table_name)
        end

        def table_description
          @table_description ||= source_config.dig(:table_descriptions, table_name, :description)
        end

        def table_overrides
          @table_overrides ||=
            source_config.dig(:table_overrides, table_name) ||
            {}
        end
      end
    end
  end
end
