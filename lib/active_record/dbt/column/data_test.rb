# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class DataTest
        include ActiveRecord::Dbt::Column::DataTestable::AcceptedValuesDataTestable
        include ActiveRecord::Dbt::Column::DataTestable::NotNullDataTestable
        include ActiveRecord::Dbt::Column::DataTestable::RelationshipsDataTestable
        include ActiveRecord::Dbt::Column::DataTestable::UniqueDataTestable
        include ActiveRecord::Dbt::Validation::TableNameValidator

        attr_reader :table_name, :column, :primary_keys, :foreign_keys

        delegate :name, to: :column, prefix: true
        delegate :source_config, to: :@config

        def initialize(table_name, column, primary_keys: [], foreign_keys: [{}])
          @config = ActiveRecord::Dbt::Config.instance
          @table_name = validate_table_name(table_name, @config)
          @column = column
          @primary_keys = primary_keys
          @foreign_keys = foreign_keys
        end

        def properties
          (data_tests.keys | data_tests_overrides_hash.keys).map do |key|
            data_tests_overrides_hash[key] || data_tests[key]
          end.presence
        end

        private

        def data_tests
          {
            'unique_test' => unique_test,
            'not_null_test' => not_null_test,
            'relationships_test' => relationships_test,
            'accepted_values_test' => accepted_values_test
          }.compact
        end

        def data_tests_overrides_hash
          @data_tests_overrides_hash ||=
            data_tests_overrides.index_by do |data_tests_override|
              "#{extract_key(data_tests_override)}_test"
            end
        end

        def extract_key(item)
          item.is_a?(Hash) ? item.keys.first : item
        end

        def data_tests_overrides
          @data_tests_overrides ||=
            source_config.dig(:table_overrides, table_name, :columns, column_name, :data_tests) ||
            []
        end
      end
    end
  end
end
