# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        class Yml
          include ActiveRecord::Dbt::DataType::Mapper
          include ActiveRecord::Dbt::Seed::Enum::Base

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
            "#{source_name} #{table_description} enum #{enum_description}".strip
          end

          # TODO: Duplcated
          def table_description
            I18n.t("activerecord.models.#{singular_table_name}", default: nil)
          end

          # TODO: Duplcated
          def enum_description
            I18n.t("activerecord.attributes.#{singular_table_name}.#{enum_column_name}", default: nil)
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
              'description' => enum_description,
              'tests' => [
                unique? ? 'unique' : nil,
                null? ? nil : 'not_null'
              ].presence
            }.compact
          end

          def enum_key_column
            {
              'name' => "#{enum_column_name}_key",
              'description' => "#{enum_description}(key)",
              'tests' => [
                unique? ? 'unique' : nil,
                null? ? nil : 'not_null'
              ].presence
            }.compact
          end

          def enum_columns
            locales.each_with_object([]) do |locale, array|
              array.push(
                {
                  'name' => "#{enum_column_name}_#{locale}",
                  'description' => "#{enum_description}(#{locale})",
                  'tests' => [
                    unique? ? 'unique' : nil,
                    null? ? nil : 'not_null'
                  ].presence
                }.compact
              )
            end
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
