# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Source
      class Yml
        attr_reader :tables

        delegate :source_config, to: :@config

        def initialize(tables)
          @tables = tables
          @config = ActiveRecord::Dbt::Config.instance
        end

        def dump
          YAML.dump(config.deep_stringify_keys)
        end

        private

        def config
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
          tables.map(&:config)
        end
      end
    end
  end
end
