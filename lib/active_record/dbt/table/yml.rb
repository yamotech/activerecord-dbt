# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      class Yml
        include ActiveRecord::Dbt::Table::Base

        attr_reader :table_test, :columns

        delegate :source_config, to: :@config

        def initialize(table_name, table_test, columns)
          super(table_name)
          @table_test = table_test
          @columns = columns
        end

        def config
          {
            **table_properties,
            'columns' => columns.map(&:config)
          }.compact
        end

        private

        def table_properties
          {
            'name' => table_name,
            'description' => description,
            **table_overrides.except(:columns),
            'tests' => table_test.config
          }
        end

        def description
          return logical_name if table_description.blank?

          [
            "# #{logical_name}",
            table_description
          ].join("\n")
        end

        def logical_name
          @logical_name ||=
            source_config.dig(:table_descriptions, table_name, :logical_name) ||
            I18n.t("activerecord.models.#{table_name.singularize}", default: nil) ||
            "Write a logical_name of the '#{table_name}' table."
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
