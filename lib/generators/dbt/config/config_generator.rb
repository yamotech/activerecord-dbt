module Dbt
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_source_description_file
        copy_file "descriptions.yml", ActiveRecord::Dbt::Source::Yml::SOURCE_TABLE_DESCRIPTION_PATH
      end

      private

      def source_name
        @source_name ||= ActiveRecord::Dbt::Config.instance.source_name
      end
    end
  end
end
