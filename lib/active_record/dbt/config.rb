# frozen_string_literal: true

require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      include ActiveRecord::Dbt::Configuration::DataSync
      include ActiveRecord::Dbt::Configuration::DwhPlatform
      include ActiveRecord::Dbt::Configuration::Logger
      include ActiveRecord::Dbt::Configuration::Parser
      include ActiveRecord::Dbt::Configuration::UsedDbtPackage

      DEFAULT_CONFIG_DIRECTORY_PATH = 'lib/dbt'
      DEFAULT_EXPORT_DIRECTORY_PATH = 'doc/dbt'

      attr_writer :config_directory_path, :export_directory_path

      def source_config_path
        @source_config_path ||= "#{config_directory_path}/source_config.yml"
      end

      def source_config
        @source_config ||= parse_yaml(source_config_path)
      end

      def source_name
        @source_name ||= source_config.dig(:sources, :name).tap do |source_name|
          raise SourceNameIsNullError, "'sources.name' is required in '#{source_config_path}'." if source_name.nil?
        end
      end

      def config_directory_path
        @config_directory_path ||= DEFAULT_CONFIG_DIRECTORY_PATH
      end

      def export_directory_path
        @export_directory_path ||= DEFAULT_EXPORT_DIRECTORY_PATH
      end

      def locale=(locale = I18n.locale)
        I18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
        I18n.locale = locale
      end

      class SourceNameIsNullError < StandardError; end
    end
  end
end
