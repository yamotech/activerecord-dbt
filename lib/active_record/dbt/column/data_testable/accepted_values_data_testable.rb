# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module DataTestable
        module AcceptedValuesDataTestable
          extend ActiveRecord::Dbt::RequiredMethods

          using ActiveRecord::Dbt::CoreExt::ActiveRecordExt

          define_required_methods :@config, :column, :table_name, :column_name

          delegate :add_log, to: :@config

          def accepted_values_test
            return nil if values.blank?

            {
              'accepted_values' => {
                'arguments' => {
                  'values' => values,
                  'quote' => quote?
                }
              }
            }
          end

          private

          def values
            if column_type == :boolean
              [true, false]
            elsif column.sql_type == 'tinyint(1)'
              [0, 1]
            elsif enum_values.present?
              enum_accepted_values
            else
              []
            end
          end

          def enum_accepted_values
            enum_values.compact.map { |key| quote? ? key.to_s : key }
          end

          def enum_values
            @enum_values ||= enums[column_name]&.values
          end

          def enums
            table_name.singularize.classify.constantize.defined_enums
          rescue NameError => e
            add_log(self.class, e)

            {}
          end

          def quote?
            @quote ||= %i[integer boolean].exclude?(column_type)
          end

          # MEMO: With `delegate :type, to: :column, prefix: true` I could not rewrite the type method with a refine.
          def column_type
            @column_type ||= column.type
          end
        end
      end
    end
  end
end
