module ActiveRecord
  module Dbt
    module Parser
      def parse_yaml(path)
        return {} if path.nil?

        YAML.load_file(path).with_indifferent_access || {}
      end
    end
  end
end
