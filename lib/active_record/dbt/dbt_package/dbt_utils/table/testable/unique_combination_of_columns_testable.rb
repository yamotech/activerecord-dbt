# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DbtPackage
      module DbtUtils
        module Table
          module Testable
            module UniqueCombinationOfColumnsTestable
              REQUIRED_UNIQUE_COMBINATION_OF_COLUMNS_TESTABLE_METHODS = %i[table_name @config].freeze

              delegate :used_dbt_utils?, to: :@config

              REQUIRED_UNIQUE_COMBINATION_OF_COLUMNS_TESTABLE_METHODS.each do |method_name|
                define_method(method_name) do
                  raise NotImplementedError, "You must implement #{self.class}##{__method__}"
                end
              end

              def unique_combination_of_columns_test
                return nil unless used_dbt_utils?

                ActiveRecord::Base.connection.indexes(table_name).each_with_object([]) do |index, array|
                  next if index.unique == false
                  next if (unique_indexes = index.columns).size == 1

                  array.push(
                    {
                      'dbt_utils.unique_combination_of_columns' => {
                        'combination_of_columns' => unique_indexes
                      }
                    }
                  )
                end.presence
              end
            end
          end
        end
      end
    end
  end
end
