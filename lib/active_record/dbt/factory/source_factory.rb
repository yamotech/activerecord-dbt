# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module SourceFactory
        def self.build
          tables_factory = ActiveRecord::Dbt::Factory::TablesFactory.build
          config = ActiveRecord::Dbt::Source::Yml.new(tables_factory).config

          YAML.dump(config.deep_stringify_keys)
        end
      end
    end
  end
end
