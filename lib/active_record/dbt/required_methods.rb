# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module RequiredMethods
      def define_required_methods(*methods)
        methods.each do |method_name|
          define_method(method_name) do
            raise RequiredImplementationMissingError, "You must implement #{self.class}##{__method__}"
          end
        end
      end

      class RequiredImplementationMissingError < StandardError; end
    end
  end
end
