module ActiveRecord
  module Dbt
    module Factory
      module ColumnsFactory
        def self.build(table_name)
          ActiveRecord::Base.connection.columns(table_name).map do |column|
            ActiveRecord::Dbt::Column::Column.new(table_name, column)
          end
        end
      end
    end
  end
end
