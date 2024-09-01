# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module TableFactory
        def self.build(table_name)
          table_data_test = ActiveRecord::Dbt::Table::DataTest.new(table_name)
          columns = ActiveRecord::Dbt::Factory::Columns::YmlFactory.build(table_name)

          ActiveRecord::Dbt::Table::Yml.new(table_name, table_data_test, columns)
        end
      end
    end
  end
end
