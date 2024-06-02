module Dbt
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_source_description_file
        copy_file "descriptions.yml", config.description_path
      end

      private

      def config
        @config ||= ActiveRecord::Dbt::Config.instance
      end
    end
  end
end
