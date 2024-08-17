# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        class Yml
          include ActiveRecord::Dbt::Column::Testable::UniqueTestable
          include ActiveRecord::Dbt::Column::Testable::NotNullTestable
          include ActiveRecord::Dbt::DataType::Mapper
          include ActiveRecord::Dbt::I18nWrapper::Translate
          include ActiveRecord::Dbt::Seed::Enum::Base

          delegate :source_config, to: :@config

          alias column_name enum_column_name

          def export_path
            "#{basename}.yml"
          end

          def dump
            YAML.dump(seed_config.deep_stringify_keys)
          end

          private

          def seed_config
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
            default_seed_description ||
              "#{source_name} #{translated_table_name} #{translated_attribute_name} enum".strip
          end

          def default_seed_description
            source_config.dig(:defaults, :seed_descriptions, :enum, :description)
                         &.gsub(/{{\s*source_name\s*}}/, source_name)
                         &.gsub(/{{\s*translated_table_name\s*}}/, translated_table_name)
                         &.gsub(/{{\s*translated_attribute_name\s*}}/, translated_attribute_name)
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
              'description' => translated_attribute_name,
              'data_tests' => data_tests
            }.compact
          end

          def enum_key_column
            {
              'name' => "#{enum_column_name}_key",
              'description' => "#{translated_attribute_name}(key)",
              'data_tests' => data_tests
            }.compact
          end

          def enum_columns
            locales.each_with_object([]) do |locale, array|
              array.push(
                {
                  'name' => "#{enum_column_name}_#{locale}",
                  'description' => "#{translated_attribute_name}(#{locale})",
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
