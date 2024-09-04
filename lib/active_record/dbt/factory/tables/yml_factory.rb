# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module Tables
        module YmlFactory
          def self.build
            config = ActiveRecord::Dbt::Config.instance
            table_names = ActiveRecord::Base.connection.tables - config.exclude_table_names

            table_names.sort.map do |table_name|
              ActiveRecord::Dbt::Factory::Table::YmlFactory.build(table_name)
            end
          end
        end
      end
    end
  end
end
