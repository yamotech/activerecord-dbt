# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        module Base
          attr_reader :table_name, :enum_column_name

          delegate :source_name, :export_directory_path, to: :@config

          def initialize(table_name, enum_column_name)
            @table_name = table_name
            @enum_column_name = enum_column_name
            @config = ActiveRecord::Dbt::Config.instance
          end

          private

          def basename
            "#{export_directory_path}/#{seed_name}"
          end

          def singular_table_name
            table_name.singularize
          end

          def seed_name
            "seed_#{source_name}__#{singular_table_name}_enum_#{enum_pluralized}"
          end

          def locales
            @locales ||= I18n.available_locales
          end

          def application_record_klass
            @application_record_klass ||= singular_table_name.classify.constantize
          rescue NameError => _e
            raise DoesNotExistTableError, "#{table_name} table does not exist."
          end

          def enum_pluralized
            enum_column_name.pluralize
          end

          class DoesNotExistTableError < StandardError; end
        end
      end
    end
  end
end
