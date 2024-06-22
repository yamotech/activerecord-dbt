# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module Testable
        module AcceptedValuesTestable
          REQUIRED_ACCEPTED_VALUES_TESTABLE_METHODS = %i[@config type table_name name].freeze

          delegate :add_log, to: :@config

          REQUIRED_ACCEPTED_VALUES_TESTABLE_METHODS.each do |method_name|
            define_method(method_name) do
              raise NotImplementedError, "You must implement #{self.class}##{__method__}"
            end
          end

          def accepted_values_test
            return nil unless type == :boolean || enum_values.present?

            {
              'accepted_values' => {
                'values' => values,
                'quote' => quote?
              }
            }
          end

          private

          def values
            type == :boolean ? [true, false] : enum_accepted_values
          end

          def enum_accepted_values
            enum_values.map { |key| quote? ? key.to_s : key }
          end

          def enum_values
            @enum_values ||= enums[name]&.values
          end

          def enums
            table_name.singularize.classify.constantize.defined_enums
          rescue NameError => e
            add_log(self.class, e)

            {}
          end

          def quote?
            @quote ||= %i[integer boolean].exclude?(type)
          end
        end
      end
    end
  end
end
