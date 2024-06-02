module ActiveRecord
  module Dbt
    module Column
      module Testable
        module UniqueTestable
          REQUIRED_UNIQUE_TESTABLE_METHODS = %i[table_name name primary_keys].freeze

          REQUIRED_UNIQUE_TESTABLE_METHODS.each do |method_name|
            define_method(method_name) do
              raise NotImplementedError, "You must implement #{self.class}##{__method__}"
            end
          end

          def unique_test
            unique? ? 'unique' : nil
          end

          private

          def unique?
            primary_keys.include?(name) || unique_columns.include?(name)
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
