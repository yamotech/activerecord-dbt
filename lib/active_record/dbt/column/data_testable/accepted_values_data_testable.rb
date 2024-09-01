# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module DataTestable
        module AcceptedValuesDataTestable
          extend ActiveRecord::Dbt::RequiredMethods

          define_required_methods :@config, :column, :table_name, :column_name

          delegate :type, to: :column, prefix: true
          delegate :add_log, to: :@config

          def accepted_values_test
            return nil unless column_type == :boolean || enum_values.present?

            {
              'accepted_values' => {
                'values' => values,
                'quote' => quote?
              }
            }
          end

          private

          def values
            column_type == :boolean ? [true, false] : enum_accepted_values
          end

          def enum_accepted_values
            enum_values.map { |key| quote? ? key.to_s : key }
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
        end
      end
    end
  end
end
