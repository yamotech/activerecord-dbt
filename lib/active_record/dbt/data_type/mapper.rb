# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module Mapper
        extend ActiveRecord::Dbt::RequiredMethods

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

        # [Platform-specific data types | dbt Developer Hub](https://docs.getdbt.com/reference/resource-properties/data-types)
        RUBY_TO_DWH_PLATFORM_TYPE_MAP = {
          'bigquery' => RUBY_TO_BIGQUERY_TYPES,
          'postgres' => RUBY_TO_POSTGRES_TYPES,
          'redshift' => RUBY_TO_REDSHIFT_TYPES,
          'snowflake' => RUBY_TO_SNOWFLAKE_TYPES,
          'spark' => RUBY_TO_SPARK_TYPES
        }.freeze

        define_required_methods :@config

        delegate :dwh_platform, to: :@config

        private

        def data_type(type)
          RUBY_TO_DWH_PLATFORM_TYPE_MAP[dwh_platform].fetch(type, 'unknown')
        end
      end
    end
  end
end
