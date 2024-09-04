# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module CoreExt
      module ActiveRecordExt
        if defined?(ActiveRecord::ConnectionAdapters::MySQL::Column)
          refine ActiveRecord::ConnectionAdapters::MySQL::Column do
            def type
              sql_type == 'tinyint(1)' ? :integer : super
            end
          end
        end
      end
    end
  end
end
