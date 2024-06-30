# frozen_string_literal: true

require 'active_record/dbt'

ActiveRecord::Dbt.configure do |c|
  c.source_config_path = 'lib/dbt/source_config.yml'
  c.export_directory_path = 'doc/dbt'
  c.data_sync_delayed = false
  c.used_dbt_package_names = []
end
