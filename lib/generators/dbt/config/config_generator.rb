# frozen_string_literal: true

module Dbt
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_source_config_file
        template 'source_config.yml.tt', source_config_path, application_name
      end

      private

      def source_config_path
        ActiveRecord::Dbt::Config.instance.source_config_path
      end

      def application_name
        Rails.application.class.name.sub(/::Application$/, '').downcase
      end
    end
  end
end
