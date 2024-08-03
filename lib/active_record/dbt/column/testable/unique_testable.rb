# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module Testable
        module UniqueTestable
          extend ActiveRecord::Dbt::RequiredMethods

          define_required_methods :table_name, :column_name, :primary_keys

          def unique_test
            unique? ? 'unique' : nil
          end

          private

          def unique?
            primary_keys.include?(column_name) || unique_columns.include?(column_name)
          end

          def unique_columns
            ActiveRecord::Base.connection.indexes(table_name).each_with_object([]) do |index, array|
              if index.unique == true && (unique_indexes = index.columns).size == 1
                array << unique_indexes.first
              end
            end
          end
        end
      end
    end
  end
end
