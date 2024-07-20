# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Model
      module Staging
        module Base
          SORT_COLUMN_TYPES = %w[
            ids enums
            strings texts
            integers floats decimals
            binaries booleans
            dates times
            datetimes timestamps
          ].freeze

          delegate :source_name, :export_directory_path, to: :@config

          def initialize(table_name)
            @table_name = table_name
            @config = ActiveRecord::Dbt::Config.instance
          end

          def rename_primary_id
            @rename_primary_id ||= primary_key_eql_id? ? "#{table_name.singularize}_id" : nil
          end

          def primary_key_eql_id?
            single_column_primary_key? && primary_keys.first == 'id'
          end

          def primary_key?(column_name)
            primary_keys.include?(column_name)
          end

          private

          def basename
            "#{export_directory_path}/#{model_name}"
          end

          def model_name
            "stg_#{source_name}__#{table_name}"
          end

          def single_column_primary_key?
            primary_keys.size == 1
          end

          def primary_keys
            @primary_keys = ActiveRecord::Base.connection.primary_keys(table_name)
          end

          def id?(column_name)
            primary_key?(column_name) || foreign_key?(column_name)
          end

          def enum?(column_name)
            table_name.singularize.classify.constantize.defined_enums.include?(column_name)
          rescue NameError => e
            add_log(self.class, e)

            false
          end

          def foreign_key?(column_name)
            ActiveRecord::Base.connection.foreign_key_exists?(table_name, column: column_name)
          end
        end
      end
    end
  end
end
