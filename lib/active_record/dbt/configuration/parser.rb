# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module Parser
        def parse_yaml(path)
          return {} if path.nil?

          YAML.safe_load_file(path)&.with_indifferent_access || {}
        end
      end
    end
  end
end
