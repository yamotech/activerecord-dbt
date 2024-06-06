ActiveRecord::Dbt.configure do |c|
  c.description_path = "lib/dbt/descriptions.yml"
  c.data_sync_delayed = false
  c.used_dbt_package_names = []
end
