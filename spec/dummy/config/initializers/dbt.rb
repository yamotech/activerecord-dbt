# frozen_string_literal: true

require 'active_record/dbt'

ActiveRecord::Dbt.configure do |c|
  c.config_directory_path = 'lib/dbt'
  c.export_directory_path = 'doc/dbt'
  c.data_sync_delayed = false
  c.logger = Logger.new($stdout)
  c.used_dbt_package_names = [
    'dbt-labs/dbt_utils',
    'datnguye/dbterd'
  ]
end
