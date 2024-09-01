# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module TablesFactory
        def self.build
          ActiveRecord::Base.connection.tables.sort.map do |table_name|
            ActiveRecord::Dbt::Factory::Table::YmlFactory.build(table_name)
          end
        end
      end
    end
  end
end
