# frozen_string_literal: true

require 'csv'

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        class Csv
          include ActiveRecord::Dbt::Seed::Enum::Base

          def export_path
            "#{basename}.csv"
          end

          def dump
            CSV.generate(headers: true) do |csv|
              rows.each { |row| csv << row }
            end
          end

          private

          def rows
            [
              header,
              *enum_rows
            ]
          end

          def header
            [
              "#{enum_column_name}_before_type_of_cast",
              "#{enum_column_name}_key",
              *locale_header
            ]
          end

          def locale_header
            locales.map { |locale| "#{enum_column_name}_#{locale}" }
          end

          def enum_rows
            enums.map do |enum_key, enum_before_type_of_cast|
              [
                enum_before_type_of_cast,
                enum_key,
                *enum_values(enum_key)
              ]
            end
          end

          def enums
            application_record_klass.defined_enums.fetch(enum_column_name)
          rescue KeyError => _e
            raise NotEnumColumnError, "#{table_name}.#{enum_column_name} column is not an enum." if enum_column?

            raise DoesNotExistColumnError, "The #{enum_column_name} column in the #{table_name} table does not exist."
          end

          def enum_column?
            application_record_klass.column_names.include?(enum_column_name)
          end

          def enum_values(enum_key)
            locales.map { |locale| translated_enum_value(enum_key, locale) }
          end

          def translated_enum_value(enum_key, locale)
            I18n.t(
              "activerecord.enum.#{singular_table_name}.#{enum_column_name}.#{enum_key}",
              locale: locale,
              default: nil
            )
          end

          class DoesNotExistColumnError < StandardError; end
          class NotEnumColumnError < StandardError; end
        end
      end
    end
  end
end
