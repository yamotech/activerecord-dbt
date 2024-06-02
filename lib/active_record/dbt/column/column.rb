module ActiveRecord
  module Dbt
    module Column
      class Column
        include ActiveRecord::Dbt::Parser

        attr_reader :table_name, :column, :column_test, :descriptions

        delegate :name, to: :column

        def initialize(table_name, column, column_test)
          @table_name = table_name
          @column = column
          @column_test = column_test
          @descriptions = parse_yaml(ActiveRecord::Dbt::Source::Yml::SOURCE_TABLE_DESCRIPTION_PATH)
        end

        def config
          {
            "name" => name,
            "description" => description,
            "tests" => column_test.config
          }.compact
        end

        private

        # TODO: I18n
        def description
          @description ||=
            descriptions.dig(:tables, table_name, :columns, name) ||
            i18n_text("activerecord.attributes.#{table_name.singularize}.#{name}") ||
            "Write a description of the #{table_name}.#{name} column."
        end

        def i18n_text(text)
          # TODO: I18n
          I18n.t(text, raise: true)
        rescue I18n::MissingTranslationData
          nil
        end
      end
    end
  end
end
