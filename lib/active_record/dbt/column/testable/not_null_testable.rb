# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module Testable
        module NotNullTestable
          extend ActiveRecord::Dbt::RequiredMethods

          define_required_methods :column

          def not_null_test
            null? ? nil : 'not_null'
          end

          private

          def null?
            column.null == true
          end
        end
      end
    end
  end
end
