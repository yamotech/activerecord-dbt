module ActiveRecord
  module Dbt
    module Configuration
      module UsedDbtPackage
        attr_writer :used_dbt_package_names

        def used_dbt_utils?
          used_dbt_package_names.include?('dbt-labs/dbt_utils')
        end

        def used_dbterd?
          used_dbt_package_names.include?('datnguye/dbterd')
        end

        private

        def used_dbt_package_names
          @used_dbt_package_names ||= []
        end
      end
    end
  end
end
