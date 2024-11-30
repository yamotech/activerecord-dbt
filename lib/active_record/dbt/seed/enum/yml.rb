# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        class Yml
          include ActiveRecord::Dbt::Column::DataTestable::UniqueDataTestable
          include ActiveRecord::Dbt::Column::DataTestable::NotNullDataTestable
          include ActiveRecord::Dbt::DataType::Mapper
          include ActiveRecord::Dbt::Seed::Enum::Base

          attr_reader :table, :enum_column

          delegate :source_config, :project_name, to: :@config
          delegate :fetch_logical_name, to: :table

          alias column_name enum_column_name

          def initialize(table, enum_column)
            @table = table
            @enum_column = enum_column
            super(table.table_name, enum_column.column_name)
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
              'seeds' => [
                'name' => seed_name,
                'description' => seed_description,
                'config' => {
                  'column_types' => column_types
                }
              ],
              'columns' => columns
            }
          end

          def seed_description
            source_config_description.gsub(/{{\s*project_name\s*}}/, project_name)
                                     .gsub(/{{\s*table_logical_name\s*}}/, fetch_logical_name)
                                     .gsub(/{{\s*column_description\s*}}/, column_description)
          end

          def source_config_description
            source_config.dig(:defaults, :seed_descriptions, :enum, :description) ||
              '{{ project_name }} {{ table_logical_name }} {{ column_description }} enum'
          end

          def column_description
            @column_description ||=
              enum_column.column_description ||
              enum_column_name
          end

          def column_types
            {
              "#{enum_column_name}_before_type_of_cast" => data_type(before_type_of_cast_type),
              "#{enum_column_name}_key" => data_type(:string),
              **enum_column_types
            }
          end

          def before_type_of_cast_type
            application_record_klass.columns_hash[enum_column_name].type
          end

          def enum_column_types
            locales.each_with_object({}) do |locale, hash|
              hash["#{enum_column_name}_#{locale}"] = data_type(:string)
            end
          end

          def columns
            [
              before_type_of_cast_column,
              enum_key_column,
              *enum_columns
            ].compact
          end

          def before_type_of_cast_column
            {
              'name' => "#{enum_column_name}_before_type_of_cast",
              'description' => "#{column_description}(before_type_of_cast)",
              'data_type' => data_type(before_type_of_cast_type),
              'data_tests' => data_tests
            }.compact
          end

          def enum_key_column
            {
              'name' => "#{enum_column_name}_key",
              'description' => "#{column_description}(key)",
              'data_type' => data_type(:string),
              'data_tests' => data_tests
            }.compact
          end

          def enum_columns
            locales.each_with_object([]) do |locale, array|
              array.push(
                {
                  'name' => "#{enum_column_name}_#{locale}",
                  'description' => "#{column_description}(#{locale})",
                  'data_type' => data_type(:string),
                  'data_tests' => data_tests
                }.compact
              )
            end
          end

          def data_tests
            [
              unique_test,
              not_null_test
            ].compact.presence
          end

          # MEMO: I think all enums are unique.
          def unique?
            true
          end

          # MEMO: I think all enums are null.
          def null?
            false
          end
        end
      end
    end
  end
end
