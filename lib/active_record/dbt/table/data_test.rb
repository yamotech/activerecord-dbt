# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      class DataTest
        include ActiveRecord::Dbt::DbtPackage::DbtUtils::Table::DataTestable::UniqueCombinationOfColumnsDataTestable

        include ActiveRecord::Dbt::Table::Base

        def properties
          [
            *unique_combination_of_columns_test
          ].compact.presence
        end
      end
    end
  end
end
