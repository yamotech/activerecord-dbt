module Dbt
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_source_header_file
        template "source_header.yml.tt", "lib/dbt/source_header.yml", source_name
      end

      def create_source_header_markdown_file
        template "source_header.md.tt", "lib/dbt/source_header.md", source_name
      end

      def copy_source_description_file
        copy_file "descriptions.yml", "lib/dbt/descriptions.yml"
      end

      private

      def source_name
        @source_name ||= ActiveRecord::Dbt::Config.instance.source_name
      end
    end
  end
end
