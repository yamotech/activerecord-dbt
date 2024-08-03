# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module DwhPlatform
        module Redshift
          # TODO: I have not tried it. I don't know if this is the correct data_type.
          # [Data types - Amazon Redshift](https://docs.aws.amazon.com/redshift/latest/dg/c_Supported_data_types.html)
          RUBY_TO_REDSHIFT_TYPES = {
            binary: 'varbyte',
            boolean: 'bool',
            date: 'date',
            datetime: 'timestamp',
            decimal: 'decimal',
            float: 'double precision',
            integer: 'integer',
            json: 'super',
            string: 'varchar',
            text: 'varchar',
            time: 'time'
          }.freeze
        end
      end
    end
  end
end
