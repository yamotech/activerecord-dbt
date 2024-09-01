# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module Source
        module YmlFactory
          def self.build
            tables_factory = ActiveRecord::Dbt::Factory::Tables::YmlFactory.build

            ActiveRecord::Dbt::Source::Yml.new(tables_factory)
          end
        end
      end
    end
  end
end
