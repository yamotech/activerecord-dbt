module ActiveRecord
  module Dbt
    module Source
      class Yml
        SOURCE_TABLE_DESCRIPTION_PATH = "lib/dbt/descriptions.yml".freeze

        attr_reader :config

        include ActiveRecord::Dbt::Parser

        def initialize
          @config = parse_yaml(SOURCE_TABLE_DESCRIPTION_PATH)
        end
      end
    end
  end
end
