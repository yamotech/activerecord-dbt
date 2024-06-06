module ActiveRecord
  module Dbt
    module Configuration
      module UsedDbtPackage
        attr_writer :used_dbt_package_names

        private

        def used_dbt_package_names
          @used_dbt_package_names ||= []
        end
      end
    end
  end
end
