# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Column
        attr_reader :table_name, :column, :column_test

        delegate :name, to: :column
        delegate :descriptions, to: :@config

        def initialize(table_name, column, column_test)
          @table_name = table_name
          @column = column
          @column_test = column_test
          @config = ActiveRecord::Dbt::Config.instance
        end

        def config
          {
            "name" => name,
            "description" => description,
            "tests" => column_test.config
          }.compact
        end

        private

        def description
          @description ||=
            descriptions.dig(:tables, table_name, :columns, name) ||
            I18n.t("activerecord.attributes.#{table_name.singularize}.#{name}", default: nil) ||
            "Write a description of the #{table_name}.#{name} column."
        end
      end
    end
  end
end
