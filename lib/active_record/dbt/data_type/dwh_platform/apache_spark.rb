# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module DwhPlatform
        module ApacheSpark
          # TODO: I have not tried it. I don't know if this is the correct data_type.
          # [Data Types - Spark 3.5.1 Documentation](https://spark.apache.org/docs/latest/sql-ref-datatypes.html)
          RUBY_TO_SPARK_TYPES = {
            binary: 'binary',
            boolean: 'boolean',
            date: 'date',
            datetime: 'timestamp',
            decimal: 'decimal',
            float: 'float',
            integer: 'integer',
            json: 'string',
            string: 'string',
            text: 'string',
            time: 'string'
          }.freeze
        end
      end
    end
  end
end
