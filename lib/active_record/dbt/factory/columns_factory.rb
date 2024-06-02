module ActiveRecord
  module Dbt
    module Factory
      module ColumnsFactory
        def self.build(
          table_name,
          primary_keys: ActiveRecord::Base.connection.primary_keys(table_name),
          foreign_keys: ActiveRecord::Base.connection.foreign_keys(table_name)
        )
          ActiveRecord::Base.connection.columns(table_name).map do |column|
            column_test = ActiveRecord::Dbt::Column::Test.new(
              table_name,
              column,
              primary_keys: primary_keys,
              foreign_keys: foreign_keys
            )

            ActiveRecord::Dbt::Column::Column.new(table_name, column, column_test)
          end
        end
      end
    end
  end
end