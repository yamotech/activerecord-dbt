# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      module DataTestable
        module RelationshipsDataTestable
          include ActiveRecord::Dbt::DbtPackage::Dbterd::Column::DataTestable::RelationshipsMetaRelationshipType

          extend ActiveRecord::Dbt::RequiredMethods

          define_required_methods :@config, :foreign_keys, :column_name

          delegate :source_name, :data_sync_delayed?, :exclude_table_names, to: :@config
          delegate :to_table, to: :foreign_key

          def relationships_test
            return nil if foreign_key.blank? || exclude_table_names.include?(to_table)

            {
              'relationships' => {
                'arguments' => relationships_arguments,
                'config' => relationships_config
              }.compact
            }
          end

          private

          def primary_key
            foreign_key.dig(:options, :primary_key)
          end

          def foreign_key
            @foreign_key ||= foreign_keys.find do |fk|
              fk.dig(:options, :column) == column_name
            end
          end

          def relationships_arguments
            {
              'to' => "source('#{source_name}', '#{to_table}')",
              'field' => primary_key,
              'meta' => relationships_meta_relationship_type
            }
          end

          def relationships_config
            return nil unless data_sync_delayed?

            {
              'severity' => 'warn'
            }
          end
        end
      end
    end
  end
end
