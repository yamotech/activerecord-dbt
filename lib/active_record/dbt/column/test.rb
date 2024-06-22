# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Column
      class Test
        include ActiveRecord::Dbt::Column::Testable::AcceptedValuesTestable
        include ActiveRecord::Dbt::Column::Testable::NotNullTestable
        include ActiveRecord::Dbt::Column::Testable::RelationshipsTestable
        include ActiveRecord::Dbt::Column::Testable::UniqueTestable

        attr_reader :table_name, :column, :primary_keys, :foreign_keys

        delegate :name, :type, to: :column
        delegate :descriptions, to: :@config

        def initialize(table_name, column, primary_keys: [], foreign_keys: [{}])
          @table_name = table_name
          @column = column
          @primary_keys = primary_keys
          @foreign_keys = foreign_keys
          @config = ActiveRecord::Dbt::Config.instance
        end

        def config
          (tests.keys | tests_overrides_hash.keys).map do |key|
            tests_overrides_hash[key] || tests[key]
          end.presence
        end

        private

        def tests
          {
            'unique_test' => unique_test,
            'not_null_test' => not_null_test,
            'relationships_test' => relationships_test,
            'accepted_values_test' => accepted_values_test
          }.compact
        end

        def tests_overrides_hash
          @tests_overrides_hash ||=
            tests_overrides.index_by do |tests_override|
              "#{extract_key(tests_override)}_test"
            end
        end

        def extract_key(item)
          item.is_a?(Hash) ? item.keys.first : item
        end

        def tests_overrides
          @tests_overrides ||=
            descriptions.dig(:table_overrides, table_name, :columns, name, :tests) ||
            []
        end
      end
    end
  end
end
