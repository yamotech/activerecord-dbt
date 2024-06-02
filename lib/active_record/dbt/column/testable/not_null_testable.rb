module ActiveRecord
  module Dbt
    module Column
      module Testable
        module NotNullTestable
          REQUIRED_NOT_NULL_TESTABLE_METHODS = %i[column].freeze

          REQUIRED_NOT_NULL_TESTABLE_METHODS.each do |method_name|
            define_method(method_name) do
              raise NotImplementedError, "You must implement #{self.class}##{__method__}"
            end
          end

          def not_null_test
            column.null == true ? nil : 'not_null'
          end
        end
      end
    end
  end
end
