module ActiveRecord
  module Dbt
    module Table
      class Yml
        include ActiveRecord::Dbt::Parser

        attr_reader :name, :descriptions

        def initialize(name)
          @name = name
          @descriptions = parse_yaml(ActiveRecord::Dbt::Source::Yml::SOURCE_TABLE_DESCRIPTION_PATH)
        end

        def config
          {
            "name" => name,
            "description" => description,
            # "columns" => columns
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
