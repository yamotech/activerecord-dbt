# frozen_string_literal: true

require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      include ActiveRecord::Dbt::Configuration::DataSync
      include ActiveRecord::Dbt::Configuration::DwhPlatform
      include ActiveRecord::Dbt::Configuration::Logger
      include ActiveRecord::Dbt::Configuration::Source
      include ActiveRecord::Dbt::Configuration::UsedDbtPackage

      def locale=(locale = I18n.locale)
        I18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]
        I18n.locale = locale
      end
    end
  end
end
