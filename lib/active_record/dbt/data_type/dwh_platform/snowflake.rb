# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module DwhPlatform
        module Snowflake
          # TODO: I have not tried it. I don't know if this is the correct data_type.
          # [Summary of data types | Snowflake Documentation](https://docs.snowflake.com/en/sql-reference/intro-summary-data-types)
          RUBY_TO_SNOWFLAKE_TYPES = {
            binary: 'binary',
            boolean: 'boolean',
            date: 'date',
            datetime: 'datetime',
            decimal: 'decimal',
            float: 'float',
            integer: 'integer',
            json: 'variant',
            string: 'varchar',
            text: 'varchar',
            time: 'time'
          }.freeze
        end
      end
    end
  end
end
