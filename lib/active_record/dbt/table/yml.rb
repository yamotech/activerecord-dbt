module ActiveRecord
  module Dbt
    module Table
      class Yml
        include ActiveRecord::Dbt::Parser

        attr_reader :name, :columns, :descriptions

        def initialize(name, columns)
          @name = name
          @columns = columns
          @descriptions = parse_yaml(ActiveRecord::Dbt::Source::Yml::SOURCE_TABLE_DESCRIPTION_PATH)
        end

        def config
          {
            "name" => name,
            "description" => description,
            "columns" => columns.map(&:config)
          }
        end

        private

        def description
          return logical_name if table_description.blank?

          [
            "# #{logical_name}",
            table_description
          ].join("\n")
        end

        # TODO: I18n
        def logical_name
          @logical_name ||= descriptions.dig(:tables, name, :logical_name) ||
            I18n.t("activerecord.models.#{name.singularize}") ||
            "Write a description of the #{name} table."
        end

        def table_description
          @table_description ||= descriptions.dig(:tables, name, :description)
        end
      end
    end
  end
end
