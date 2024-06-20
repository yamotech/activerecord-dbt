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
          [
            unique_test,
            not_null_test,
            relationships_test,
            accepted_values_test
          ].compact.presence
        end
      end
    end
  end
end
