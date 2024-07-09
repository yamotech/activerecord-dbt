# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class StagingModelGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)

        def create_staging_model_yml_file
          create_file yml.export_path, yml.yml_dump
        end

        private

        def yml
          @yml ||= ActiveRecord::Dbt::Factory::Model::StagingFactory.yml_build(name)
        end
      end
    end
  end
end
