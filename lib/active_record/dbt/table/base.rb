# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Table
      module Base
        attr_reader :table_name

        def initialize(table_name)
          @table_name = table_name
          @config = ActiveRecord::Dbt::Config.instance
        end
      end
    end
  end
end
