# frozen_string_literal: true

ActiveRecord::Dbt.configure do |c|
  c.source_config_path = 'lib/dbt/source_config.yml'
  c.data_sync_delayed = false
  c.used_dbt_package_names = []
end
