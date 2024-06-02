module ActiveRecord
  module Dbt
    module Factory
      module SourceFactory
        def self.build
          ActiveRecord::Dbt::Source::Yml.new.config
        end
      end
    end
  end
end
