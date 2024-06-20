# frozen_string_literal: true

module Dbt
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_source_description_file
        template 'descriptions.yml.tt', description_path, application_name
      end

      private

      def description_path
        ActiveRecord::Dbt::Config.instance.description_path
      end

      def application_name
        Rails.application.class.name.sub(/::Application$/, '').downcase
      end
    end
  end
end
