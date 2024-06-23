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

        def config
          {
            'version' => 2,
            'sources' => [
              **source_properties,
              'tables' => tables.map(&:config)
            ]
          }
        end

        private

        def source_properties
          source_config[:sources]
        end
      end
    end
  end
end
