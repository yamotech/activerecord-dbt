# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class SourceGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        def create_source_yml_file
          create_file yml.export_path, yml.dump
        end

        private

        def yml
          @yml ||= ActiveRecord::Dbt::Factory::SourceFactory.build
        end
      end
    end
  end
end
