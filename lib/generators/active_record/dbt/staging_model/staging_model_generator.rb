# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class StagingModelGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)

        def create_staging_model_sql_file
          template 'staging_model.sql.tt', sql.export_path
        end

        def create_staging_model_yml_file
          create_file yml.export_path, yml.dump
        end

        private

        def sql
          @sql ||= ActiveRecord::Dbt::Model::Staging::Sql.new(name)
        end

        def yml
          @yml ||= ActiveRecord::Dbt::Factory::Model::Staging::YmlFactory.build(name)
        end

        def source_paths
          config_directory_path = ActiveRecord::Dbt::Config.instance.config_directory_path

          [
            File.expand_path(config_directory_path, Rails.root),
            File.expand_path('./templates/', __dir__)
          ]
        end
      end
    end
  end
end
