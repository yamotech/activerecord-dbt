module ActiveRecord
  module Dbt
    module Column
      module Testable
        module RelationshipsTestable
          REQUIRED_RELATIONSHIPS_TESTABLE_METHODS = %i[@config foreign_keys name].freeze

          delegate :source_name, to: :@config
          delegate :to_table, to: :foreign_key

          REQUIRED_RELATIONSHIPS_TESTABLE_METHODS.each do |method_name|
            define_method(method_name) do
              raise NotImplementedError, "You must implement #{self.class}##{__method__}"
            end
          end

          def relationships_test
            return nil if foreign_key.blank?

            {
              "relationships" => {
                "to" => "source('#{source_name}', '#{to_table}')",
                "field" => field
              }
            }
          end

          def field
            foreign_key.dig(:options, :primary_key)
          end

          def foreign_key
            @foreign_key ||= foreign_keys.find do |fk|
              fk.dig(:options, :column) == name
            end
          end
        end
      end
    end
  end
end
