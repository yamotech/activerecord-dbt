# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module I18nWrapper
      module Translate
        extend ActiveRecord::Dbt::RequiredMethods

        define_required_methods :table_name

        delegate :singularize, to: :table_name, prefix: true

        def translated_table_name
          I18n.t("activerecord.models.#{table_name_singularize}", default: nil)
        end

        def translated_attribute_name
          @translated_attribute_name ||=
            translated_column_name || translated_default_column_name
        end

        private

        def translated_column_name
          I18n.t("activerecord.attributes.#{table_name_singularize}.#{column_name}", default: nil)
        end

        def translated_default_column_name
          I18n.t("attributes.#{column_name}", default: nil)
        end
      end
    end
  end
end
