# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      module Base
        include ActiveRecord::Dbt::Validation::TableNameValidator

        attr_reader :table_name

        def initialize(table_name)
          @config = ActiveRecord::Dbt::Config.instance
          @table_name = validate_table_name(table_name, @config)
        end
      end
    end
  end
end
