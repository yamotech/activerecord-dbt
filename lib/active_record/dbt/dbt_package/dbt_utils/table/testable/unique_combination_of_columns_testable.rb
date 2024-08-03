# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DbtPackage
      module DbtUtils
        module Table
          module Testable
            module UniqueCombinationOfColumnsTestable
              extend ActiveRecord::Dbt::RequiredMethods

              define_required_methods :table_name, :@config

              delegate :used_dbt_utils?, to: :@config

              def unique_combination_of_columns_test
                return nil unless used_dbt_utils?

                indexes.each_with_object([]) do |index, array|
                  next if unique_indexes?(index)

                  array.push(
                    {
                      'dbt_utils.unique_combination_of_columns' => {
                        'combination_of_columns' => index.columns
                      }
                    }
                  )
                end.presence
              end

              private

              def indexes
                ActiveRecord::Base.connection.indexes(table_name)
              end

              def unique_indexes?(index)
                return true if index.unique == false

                index.columns.size == 1
              end
            end
          end
        end
      end
    end
  end
end
