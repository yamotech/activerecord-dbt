# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module DbtPackage
      module Dbterd
        module Column
          module Testable
            module RelationshipsMetaRelationshipType
              REQUIRED_RELATIONSHIP_TYPE_TESTABLE_METHODS = %i[@config foreign_key].freeze

              delegate :used_dbterd?, to: :@config

              REQUIRED_RELATIONSHIP_TYPE_TESTABLE_METHODS.each do |method_name|
                define_method(method_name) do
                  raise NotImplementedError, "You must implement #{self.class}##{__method__}"
                end
              end

              def relationships_meta_relationship_type
                return nil unless used_dbterd?
                return nil if foreign_key.nil? || relationship_type.blank?

                {
                  'relationship_type' => relationship_type
                }
              rescue NotSpecifiedOrNotInvalidIdError, StandardError => e
                puts "#{e.class}: #{e.message}"

                {
                  'relationship_type' => 'many-to-one',
                  'active_record_dbt_error' => {
                    'class' => e.class.to_s,
                    'message' => e.message.to_s
                  }
                }
              end

              private

              # MEMO: It seems to be a good idea to set only 'many-to-one', 'one-to-one', and 'many-to-one'.
              # * [Relationship Types - DaaC from dbt artifacts](https://dbterd.datnguyen.de/1.13/nav/metadata/relationship_type.html)
              # * [Syntax | DBML](https://dbml.dbdiagram.io/docs/#relationships--foreign-key-definitions)
              #   * DBML supports 'one-to-many', 'many-to-one', 'one-to-one', and 'many-to-many'.
              def relationship_type
                case
                # when one_to_many? then 'one-to-many'
                # when zero_to_many? then 'zero-to-many'
                # when many_to_many? then 'many-to-many'
                when one_to_one? then 'one-to-one'
                when many_to_one? then 'many-to-one'
                else
                  raise NotSpecifiedOrNotInvalidIdError, 'Not specified/Invalid value'
                end
              end

              # MEMO: If 'many-to-one' is specified, 'one-to-many' should not be necessary.
              # def one_to_many?
              # end

              # MEMO:
              # * It seems that `zero-to-many` cannot be specified in a dbt relationship.
              #   * The reverse may be possible, but cannot be specified in dbterd.
              # * It doesn't look like it can be configured with dbml.
              #   * [Syntax | DBML](https://dbml.dbdiagram.io/docs/#relationships--foreign-key-definitions)
              # def zero_to_many?
              # end

              # # TODO: Usually, there is always an intermediate table, so there is no `many-to-many`.
              # def many_to_many?
              #   from_model_find_association_to_model?(:has_and_belongs_to_many) &&
              #     to_model_find_association_from_model?(:has_and_belongs_to_many)
              # end

              def one_to_one?
                from_model_find_association_to_model?(:belongs_to) &&
                  to_model_find_association_from_model?(:has_one)
              end

              def many_to_one?
                from_model_find_association_to_model?(:belongs_to) &&
                  to_model_find_association_from_model?(:has_many)
              end

              def to_model_find_association_from_model?(association_type)
                to_model.reflect_on_all_associations(association_type).any? do |association|
                  association_klass(association) == from_model &&
                    association_foreign_key(association) == foreign_key_column
                end
              end

              def from_model_find_association_to_model?(association_type)
                from_model.reflect_on_all_associations(association_type).any? do |association|
                  association_klass(association) == to_model &&
                    association_foreign_key(association) == foreign_key_column
                end
              end

              def association_klass(association)
                association.klass
              rescue NoMethodError
                association.options.fetch(:through).to_s.classify.constantize
              end

              def association_foreign_key(association)
                association.foreign_key
              rescue NoMethodError
                association.options.fetch(
                  :foreign_key,
                  "#{association.active_record.to_s.underscore}_id"
                )
              end

              def foreign_key_column
                foreign_key.dig(:options, :column)
              end

              def from_model
                @from_model ||= foreign_key.from_table.classify.constantize
              end

              def to_model
                @to_model ||= foreign_key.to_table.classify.constantize
              end

              class NotSpecifiedOrNotInvalidIdError < StandardError; end
            end
          end
        end
      end
    end
  end
end