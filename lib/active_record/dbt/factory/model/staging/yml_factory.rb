# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module Model
        module Staging
          module YmlFactory
            def self.build(table_name)
              table_factory = ActiveRecord::Dbt::Factory::Table::YmlFactory.build(table_name)
              yml = ActiveRecord::Dbt::Model::Staging::Yml.new(table_factory)
              struct = Struct.new(:export_path, :dump, keyword_init: true)

              struct.new(
                export_path: yml.export_path,
                dump: yml.dump
              )
            end
          end
        end
      end
    end
  end
end
