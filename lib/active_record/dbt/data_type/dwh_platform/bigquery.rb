# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module DwhPlatform
        module Bigquery
          # [Data types  |  BigQuery  |  Google Cloud](https://cloud.google.com/bigquery/docs/reference/standard-sql/data-types#data_type_list)
          RUBY_TO_BIGQUERY_TYPES = {
            binary: 'bytes',
            boolean: 'bool',
            date: 'date',
            datetime: 'datetime',
            decimal: 'int64',
            float: 'float64',
            integer: 'int64',
            json: 'json',
            string: 'string',
            text: 'string',
            time: 'time'
          }.freeze
        end
      end
    end
  end
end
