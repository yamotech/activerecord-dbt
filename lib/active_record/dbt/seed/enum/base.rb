# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Seed
      module Enum
        module Base
          include ActiveRecord::Dbt::Validation::TableNameValidator

          attr_reader :table_name, :enum_column_name

          delegate :source_name, :export_directory_path, to: :@config
          delegate :singularize, to: :table_name, prefix: true

          def initialize(table_name, enum_column_name)
            @config = ActiveRecord::Dbt::Config.instance
            @table_name = validate_table_name(table_name, @config)
            @enum_column_name = enum_column_name
          end

          private

          def basename
            "#{export_directory_path}/seeds/#{source_name}/#{seed_name}"
          end

          def seed_name
            "seed_#{source_name}__#{table_name_singularize}_enum_#{enum_pluralized}"
          end

          def locales
            @locales ||= I18n.available_locales
          end

          def application_record_klass
            @application_record_klass ||= table_name_singularize.classify.constantize
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
