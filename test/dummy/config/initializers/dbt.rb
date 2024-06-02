ActiveRecord::Dbt.configure do |c|
  c.source_name = 'rails_dummy'
  c.description_path = "lib/dbt/descriptions.yml"
end
