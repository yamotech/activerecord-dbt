# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module Testable
        module AcceptedValuesTestable
          REQUIRED_ACCEPTED_VALUES_TESTABLE_METHODS = %i[@config column table_name column_name].freeze

          delegate :type, to: :column, prefix: true
          delegate :add_log, to: :@config

          REQUIRED_ACCEPTED_VALUES_TESTABLE_METHODS.each do |method_name|
            define_method(method_name) do
              raise RequiredImplementationMissingError, "You must implement #{self.class}##{__method__}"
            end
          end

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
