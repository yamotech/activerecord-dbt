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
        end
      end
    end
  end
end
