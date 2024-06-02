module ActiveRecord
  module Dbt
    module Parser
      def parse_yaml(path)
        return {} if path.nil?

        yaml_hash = YAML.load_file(path) || {}
        yaml_hash.with_indifferent_access
      end
    end
  end
end
