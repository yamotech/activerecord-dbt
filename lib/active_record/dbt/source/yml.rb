module ActiveRecord
  module Dbt
    module Source
      class Yml
        SOURCE_TABLE_DESCRIPTION_PATH = "lib/dbt/descriptions.yml".freeze

        attr_reader :descriptions

        include ActiveRecord::Dbt::Parser

        def initialize
          @descriptions = parse_yaml(SOURCE_TABLE_DESCRIPTION_PATH)
        end

        def config
          {
            "version" => 2,
            "sources" => [
              "name" => descriptions.dig(:sources, :name),
              "description" => descriptions.dig(:sources, :description)
            ]
          }
        end
      end
    end
  end
end
