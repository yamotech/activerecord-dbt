require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      include ActiveRecord::Dbt::Configuration::DataSync
      include ActiveRecord::Dbt::Configuration::Parser

      attr_accessor :description_path

      def descriptions
        @descriptions ||= parse_yaml(description_path)
      end

      def source_name
        @source_name ||= descriptions.dig(:sources, :name).tap do |source_name|
          raise SourceNameIsNullError, "sources.name is required in #{description_path}." if source_name.nil?
        end
      end

      class SourceNameIsNullError < StandardError; end
    end
  end
end
