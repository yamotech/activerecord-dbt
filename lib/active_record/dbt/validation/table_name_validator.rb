# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Validation
      module TableNameValidator
        def validate_table_name(table_name, config)
          return table_name if config.exclude_table_names.exclude?(table_name)

          raise TableNameIsExcludedError, "The table name '#{table_name}' is excluded in 'exclude_table_names'."
        end

        class TableNameIsExcludedError < StandardError; end
      end
    end
  end
end
