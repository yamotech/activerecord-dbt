# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module I18nConfiguration
        def locale=(locale = I18n.locale)
          I18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
          I18n.locale = locale
        end
      end
    end
  end
end
