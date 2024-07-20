# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class SourceGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        def create_source_yml_file
          create_file "#{config.export_directory_path}/src_#{config.source_name}.yml",
                      ActiveRecord::Dbt::Factory::SourceFactory.build
        end

        private

        def config
          @config ||= ActiveRecord::Dbt::Config.instance
        end
      end
    end
  end
end
