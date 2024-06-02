module ActiveRecord
  module Dbt
    module Parser
      def parse_yaml(path)
        return {} if path.nil?

        yaml_hash = YAML.load_file(path) || {}
        convert_hash(yaml_hash.with_indifferent_access)
      end

      private

      def convert_hash(hash)
        hash.each_with_object({}) do |(key, value), result|
          result[key] = convert_value(value)
        end
      end

      def convert_value(value)
        if value.is_a?(Hash)
          convert_hash(value)
        elsif value.is_a?(String) && value.match?(/\R/)
          value.split(/\R/).map(&:strip)
        else
          value
        end
      end
    end
  end
end
