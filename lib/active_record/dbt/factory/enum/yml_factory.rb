# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module Enum
        module YmlFactory
          def self.build(
            table_name,
            column_name,
            primary_keys: ActiveRecord::Base.connection.primary_keys(table_name)
          )
            column = ActiveRecord::Base.connection.columns(table_name).find{ |c| c.name == column_name }
            enum_column = ActiveRecord::Dbt::Column::Yml.new(
              table_name,
              column,
              primary_keys: primary_keys
            )

            ActiveRecord::Dbt::Seed::Enum::Yml.new(table_name, enum_column)
          end
        end
      end
    end
  end
end
