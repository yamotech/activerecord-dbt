# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Model
      module Staging
        class Yml
          include ActiveRecord::Dbt::Model::Staging::Base

          attr_reader :table

          delegate :table_name, to: :table
          delegate :source_name, :data_sync_delayed?, :used_dbterd?, to: :@config

          def initialize(table)
            @table = table
            super(table_name)
          end

          def export_path
            "#{basename}.yml"
          end

          def dump
            YAML.dump(properties.deep_stringify_keys)
          end

          private

          def properties
            {
              'version' => 2,
              'models' => [
                {
                  'name' => model_name,
                  **table.properties.except('name', 'columns'),
                  'columns' => override_columns
                }
              ]
            }
          end

          def columns
            @columns ||= sort_columns(table.properties['columns'])
          end

          def sort_columns(columns)
            columns.sort_by do |column|
              sort_column_names.index(column['name'])
            end
          end

          def sort_column_names
            @sort_column_names ||= select_column_names.values.flatten.map(&:name)
          end

          def override_columns
            return columns unless single_column_primary_key?

            columns.map { |column| override_column(column) }
          end

          def override_column(column)
            return column unless primary_key?(column['name'])

            column.tap do |c|
              add_relationship_test(c)
              rename_primary_id_in_column(c) if primary_key_eql_id?
            end
          end

          def add_relationship_test(column)
            column['data_tests'].push(relationships_test(column['name']))
          end

          def rename_primary_id_in_column(column)
            column['description'] = rename_primary_id if column['name'] == column['description']
            column['name'] = rename_primary_id
          end

          def relationships_test(column_name)
            {
              'relationships' => {
                'severity' => data_sync_delayed? ? 'warn' : nil,
                'to' => "source('#{source_name}', '#{table_name}')",
                'field' => column_name,
                'meta' => relationships_meta_relationship_type
              }.compact
            }
          end

          def relationships_meta_relationship_type
            return nil unless used_dbterd?

            {
              'relationship_type' => 'one-to-one'
            }
          end
        end
      end
    end
  end
end
