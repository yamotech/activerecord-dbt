# frozen_string_literal: true

require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      include ActiveRecord::Dbt::Configuration::DataSync
      include ActiveRecord::Dbt::Configuration::Logger
      include ActiveRecord::Dbt::Configuration::Parser
      include ActiveRecord::Dbt::Configuration::UsedDbtPackage

      attr_accessor :source_config_path

      def source_config
        @source_config ||= parse_yaml(source_config_path)
      end

      def source_name
        @source_name ||= source_config.dig(:sources, :name).tap do |source_name|
          raise SourceNameIsNullError, "sources.name is required in #{source_config_path}." if source_name.nil?
        end
      end

      class SourceNameIsNullError < StandardError; end
    end
  end
end
