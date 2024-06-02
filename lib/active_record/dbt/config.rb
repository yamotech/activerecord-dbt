require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton
      include ActiveRecord::Dbt::Configuration::Parser

      attr_accessor :description_path
      attr_writer :source_name

      def source_name
        raise SourceNameIsNullError, "source_name is required." if @source_name.nil?

        @source_name
      end

      def descriptions
        @descriptions ||= parse_yaml(description_path)
      end

      class SourceNameIsNullError < StandardError; end
    end
  end
end
