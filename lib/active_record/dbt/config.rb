require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      attr_writer :source_name

      def source_name
        raise SourceNameIsNullError, "source_name is required." if @source_name.nil?

        @source_name
      end

      class SourceNameIsNullError < StandardError; end
    end
  end
end
