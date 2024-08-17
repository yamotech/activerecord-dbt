# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Source
      class Yml
        attr_reader :tables

        delegate :source_config, :export_directory_path, :source_name, to: :@config

        def initialize(tables)
          @tables = tables
          @config = ActiveRecord::Dbt::Config.instance
        end

        def export_path
          "#{export_directory_path}/models/sources/#{source_name}/src_#{source_name}.yml"
        end

        def dump
          YAML.dump(properties.deep_stringify_keys)
        end

        private

        def properties
          {
            'version' => 2,
            'sources' => [
              source_properties.merge('tables' => tables_properties)
            ]
          }
        end

        def source_properties
          source_config[:sources]
        end

        def tables_properties
          tables.map(&:properties)
        end
      end
    end
  end
end
