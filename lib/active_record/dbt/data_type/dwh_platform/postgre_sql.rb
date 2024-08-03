# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module DwhPlatform
        module PostgreSql
          # TODO: I have not tried it. I don't know if this is the correct data_type.
          # [PostgreSQL: Documentation: 16: Chapter 8. Data Types](https://www.postgresql.org/docs/current/datatype.html)
          RUBY_TO_POSTGRES_TYPES = {
            binary: 'bytea',
            boolean: 'boolean',
            date: 'date',
            datetime: 'timestamp',
            decimal: 'bigint',
            float: 'double precision',
            integer: 'bigint',
            json: 'json',
            string: 'text',
            text: 'text',
            time: 'time'
          }.freeze
        end
      end
    end
  end
end
