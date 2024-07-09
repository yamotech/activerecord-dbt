# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module TableFactory
        def self.build(table_name)
          table_test = ActiveRecord::Dbt::Table::Test.new(table_name)
          columns = ActiveRecord::Dbt::Factory::ColumnsFactory.build(table_name)

          ActiveRecord::Dbt::Table::Yml.new(table_name, table_test, columns)
        end
      end
    end
  end
end