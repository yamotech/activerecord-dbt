# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      class Yml
        include ActiveRecord::Dbt::Table::Base

        attr_reader :table_test, :columns

        delegate :descriptions, to: :@config

        def initialize(table_name, table_test, columns)
          super(table_name)
          @table_test = table_test
          @columns = columns
        end

        def config
          {
            'name' => table_name,
            'description' => description,
            'tests' => table_test.config,
            'columns' => columns.map(&:config)
          }.compact
        end

        private

        def description
          return logical_name if table_description.blank?

          [
            "# #{logical_name}",
            table_description
          ].join("\n")
        end

        def logical_name
          @logical_name ||=
            descriptions.dig(:tables, table_name, :logical_name) ||
            I18n.t("activerecord.models.#{table_name.singularize}", default: nil) ||
            "Write a description of the #{table_name} table."
        end

        def table_description
          @table_description ||= descriptions.dig(:tables, table_name, :description)
        end
      end
    end
  end
end
