module ActiveRecord
  module Dbt
    module Table
      class Yml
        attr_reader :name, :columns

        delegate :descriptions, to: :@config

        def initialize(name, columns)
          @name = name
          @columns = columns
          @config = ActiveRecord::Dbt::Config.instance
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

        def logical_name
          @logical_name ||= descriptions.dig(:tables, name, :logical_name) ||
            I18n.t("activerecord.models.#{name.singularize}", default: nil) ||
            "Write a description of the #{name} table."
        end

        def table_description
          @table_description ||= descriptions.dig(:tables, name, :description)
        end
      end
    end
  end
end
