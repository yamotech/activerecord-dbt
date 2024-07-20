# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Factory
      module Model
        module StagingFactory
          def self.yml_build(table_name)
            table_factory = ActiveRecord::Dbt::Factory::TableFactory.build(table_name)
            yml = ActiveRecord::Dbt::Model::Staging::Yml.new(table_factory)
            struct = Struct.new(:export_path, :yml_dump, keyword_init: true)

            struct.new(
              export_path: yml.export_path,
              yml_dump: YAML.dump(yml.config.deep_stringify_keys)
            )
          end
        end
      end
    end
  end
end
