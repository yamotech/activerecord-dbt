# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module SourceFactory
        def self.build
          tables_factory = ActiveRecord::Dbt::Factory::TablesFactory.build

          ActiveRecord::Dbt::Source::Yml.new(tables_factory).dump
        end
      end
    end
  end
end
