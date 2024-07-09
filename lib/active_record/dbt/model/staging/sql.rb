# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Model
      module Staging
        class Sql
          include ActiveRecord::Dbt::Model::Staging::Base

          attr_reader :table_name

          def export_path
            "#{basename}.sql"
          end

          def select_column_names
            columns_group_by_column_type.sort_by do |key, _|
              SORT_COLUMN_TYPES.index(key)
            end.to_h
          end

          private

          def columns
            ActiveRecord::Base.connection.columns(table_name)
          end

          def columns_group_by_column_type
            columns.group_by do |column|
              if id?(column.name)
                'ids'
              else
                column.type.to_s.pluralize
              end
            end
          end
        end
      end
    end
  end
end
