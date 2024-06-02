module ActiveRecord
  module Dbt
    module Configuration
      module DataSync
        attr_writer :data_sync_delayed

        def data_sync_delayed?
          @data_sync_delayed ||= false
        end
      end
    end
  end
end
