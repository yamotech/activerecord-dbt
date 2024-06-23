# frozen_string_literal: true

ActiveRecord::Dbt.configure do |c|
  c.description_path = 'lib/dbt/descriptions.yml'
  c.data_sync_delayed = false
  c.logger = Logger.new($stdout)
  c.used_dbt_package_names = [
    'dbt-labs/dbt_utils',
    'datnguye/dbterd'
  ]
end
