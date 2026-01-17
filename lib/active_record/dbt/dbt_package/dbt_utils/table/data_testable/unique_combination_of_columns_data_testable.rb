# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DbtPackage
      module DbtUtils
        module Table
          module DataTestable
            module UniqueCombinationOfColumnsDataTestable
              extend ActiveRecord::Dbt::RequiredMethods

              define_required_methods :table_name, :@config

              delegate :used_dbt_utils?, to: :@config

              def unique_combination_of_columns_test
                return nil unless used_dbt_utils?

                indexes.each_with_object([]) do |index, array|
                  next if single_column_index?(index)

                  array.push(
                    {
                      'dbt_utils.unique_combination_of_columns' => {
                        'arguments' => unique_combination_of_columns_arguments(index.columns),
                        'config' => unique_combination_of_columns_config(index.columns)
                      }.compact
                    }
                  )
                end.presence
              end

              private

              def indexes
                ActiveRecord::Base.connection.indexes(table_name)
              end

              def single_column_index?(index)
                return true if index.unique == false

                index.columns.size == 1
              end

              def unique_combination_of_columns_arguments(combination_of_columns)
                {
                  'combination_of_columns' => combination_of_columns
                }
              end

              def unique_combination_of_columns_config(combination_of_columns)
                config_where = condition_for_unique_combination_of_columns(combination_of_columns)
                return nil if config_where.blank?

                {
                  'where' => config_where
                }
              end

              def condition_for_unique_combination_of_columns(unique_combination_of_columns)
                columns.each_with_object([]) do |column, array|
                  if unique_combination_of_columns.include?(column.name) && column.null == true
                    array.push("#{column.name} is not null")
                  end
                end.join(' and ').presence
              end

              def columns
                ActiveRecord::Base.connection.columns(table_name)
              end
            end
          end
        end
      end
    end
  end
end
