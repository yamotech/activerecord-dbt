# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module Exclude
        attr_writer :exclude_table_names

        def exclude_table_names
          @exclude_table_names ||= []
        end
      end
    end
  end
end
