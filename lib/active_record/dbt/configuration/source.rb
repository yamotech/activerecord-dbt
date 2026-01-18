# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module Source
        include ActiveRecord::Dbt::Configuration::Parser

        DEFAULT_CONFIG_DIRECTORY_PATH = 'lib/dbt'
        DEFAULT_EXPORT_DIRECTORY_PATH = 'doc/dbt'

        attr_writer :config_directory_path, :export_directory_path

        def config_directory_path
          @config_directory_path ||= DEFAULT_CONFIG_DIRECTORY_PATH
        end

        def export_directory_path
          @export_directory_path ||= DEFAULT_EXPORT_DIRECTORY_PATH
        end

        def source_config_path
          @source_config_path ||= "#{config_directory_path}/source_config.yml"
        end

        def source_config
          @source_config ||= parse_yaml(source_config_path)
        end

        def source_name
          @source_name ||= source_config.dig(:sources, :name).tap do |source_name|
            raise SourceNameIsNullError, "'sources.name' is required in '#{source_config_path}'." if source_name.nil?
          end
        end

        def project_name
          @project_name ||=
            source_config.dig(:sources, :config, :meta, :project_name) ||
            source_name
        end

        def exclude_table_names
          @exclude_table_names ||=
            source_config.dig(:sources, :config, :meta, :exclude, :table_names) ||
            []
        end

        class SourceNameIsNullError < StandardError; end
      end
    end
  end
end
