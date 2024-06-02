module ActiveRecord
  module Dbt
    module Factory
      module SourceFactory
        def self.build
          config = ActiveRecord::Dbt::Source::Yml.new.config
          YAML.dump(config)
        end
      end
    end
  end
end
