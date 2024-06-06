module ActiveRecord
  module Dbt
    module Factory
      module TablesFactory
        def self.build
          ActiveRecord::Base.connection.tables.sort.map do |table_name|
            table_test = ActiveRecord::Dbt::Table::Test.new(table_name)
            columns = ActiveRecord::Dbt::Factory::ColumnsFactory.build(table_name)

            ActiveRecord::Dbt::Table::Yml.new(table_name, table_test, columns)
          end
        end
      end
    end
  end
end
