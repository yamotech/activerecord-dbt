module Dbt
  module Generators
    class SourceGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_source_yml_file
        create_file "tmp/dbt/src_#{source_name}.yml", ActiveRecord::Dbt::Factory::SourceFactory.build
      end

      private

      def source_name
        ActiveRecord::Dbt::Config.instance.source_name
      end
    end
  end
end
