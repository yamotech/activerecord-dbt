# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DataType
      module Mapper
        include ActiveRecord::Dbt::DataType::DwhPlatform::ApacheSpark
        include ActiveRecord::Dbt::DataType::DwhPlatform::Bigquery
        include ActiveRecord::Dbt::DataType::DwhPlatform::PostgreSql
        include ActiveRecord::Dbt::DataType::DwhPlatform::Redshift
        include ActiveRecord::Dbt::DataType::DwhPlatform::Snowflake

        # [Platform-specific data types | dbt Developer Hub](https://docs.getdbt.com/reference/resource-properties/data-types)
        RUBY_TO_DWH_PLATFORM_TYPE_MAP = {
          'bigquery' => RUBY_TO_BIGQUERY_TYPES,
          'postgres' => RUBY_TO_POSTGRES_TYPES,
          'redshift' => RUBY_TO_REDSHIFT_TYPES,
          'snowflake' => RUBY_TO_SNOWFLAKE_TYPES,
          'spark' => RUBY_TO_SPARK_TYPES
        }.freeze

        REQUIRED_DATATYPE_METHODS = %i[column @config].freeze

        delegate :dwh_platform, to: :@config

        REQUIRED_DATATYPE_METHODS.each do |method_name|
          define_method(method_name) do
            raise NotImplementedError, "You must implement #{self.class}##{__method__}"
          end
        end

        private

        def data_type
          RUBY_TO_DWH_PLATFORM_TYPE_MAP[dwh_platform].fetch(column.type, 'unknown')
        end
      end
    end
  end
end
