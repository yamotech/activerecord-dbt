# frozen_string_literal: true

require 'singleton'

module ActiveRecord
  module Dbt
    class Config
      include Singleton

      include ActiveRecord::Dbt::Configuration::DataSync
      include ActiveRecord::Dbt::Configuration::DwhPlatform
      include ActiveRecord::Dbt::Configuration::I18nConfiguration
      include ActiveRecord::Dbt::Configuration::Logger
      include ActiveRecord::Dbt::Configuration::Source
      include ActiveRecord::Dbt::Configuration::UsedDbtPackage
    end
  end
end
