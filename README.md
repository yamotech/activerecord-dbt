# ActiveRecord::Dbt

Generate dbt files from the information of the database connected by ActiveRecord.

Currently, only `yaml` files of `source` can be generated.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-dbt'
```

Since it's only used in the development environment, the following settings are recommended:

```ruby
group :development do
  gem 'activerecord-dbt'
end
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install activerecord-dbt
```

## Usage

### Create dbt Source file

#### activerecord-dbt configuration

Generate `config/initializers/dbt.rb`.

```bash
$ bin/rails generate dbt:initializer
```

configuration | descrption
--------- | ---------
source_config_path | The path to the file that describes the items you want to set in source property. Default is `lib/dbt/source_config.yml`.
data_sync_delayed | Is there a data delay? If set to `true`, `serverity: warn` will be set for `relationships` test. Default is `false`.
logger | Log output destination. Default is `Logger.new($stdout)`.
used_dbt_package_names | An array of `dbt` package names used.

##### For Example:

Change the settings according to your environment.

```ruby
# frozen_string_literal: true

require 'active_record/dbt'

ActiveRecord::Dbt.configure do |c|
  c.source_config_path = 'lib/dbt/source_config.yml'
  c.data_sync_delayed = false
  c.used_dbt_package_names = [
    'dbt-labs/dbt_utils',
    'datnguye/dbterd'
  ]
end

```

#### dbt source configuration

Generate `lib/dbt/source_config.yml`.

```bash
$ bin/rails generate dbt:config
```

The items that can be set in `table_descriptions` and `table_overrides` are listed in [Source properties | dbt Developer Hub](https://docs.getdbt.com/reference/source-properties).

##### table_descriptions

configuration | descrption
--------- | ---------
logical_name | Title or one-line description to be output in dbt `description`.
description | Detailed description of `logical_name` to be output in dbt `description`.

##### table_overrides

Set all items in the table except `name` and `description`.

##### For Example:

Change the settings according to your environment.

```yml
sources:
  name: dummy
  meta:
    generated_by: activerecord-dbt
  description: |-
    Write a description of the dummy source.
    You can write multiple lines.

table_descriptions:
  ar_internal_metadata:
    logical_name: Internal Metadata
    description: |-
      By default Rails will store information about your Rails environment and schema
      in an internal table named `ar_internal_metadata`.
    columns:
      key: Key
      value: Value
      created_at: Created At
      updated_at: Updated At
  schema_migrations:
    logical_name: Schema Migrations
    description: |-
      Rails keeps track of which migrations have been committed to the database and
      stores them in a neighboring table in that same database called `schema_migrations`.
    columns:
      version: The version number of the migration.

table_overrides:
  users:
    loaded_at_field: created_at
    freshness:
      warn_after:
        count: 3
        period: day
      error_after:
        count: 5
        period: day
    columns:
      created_at:
        tests:
          - not_null:
              where: 'id != 1'

```

#### Generate `tmp/dbt/src_#{source_name}.yml`

```bash
$ bin/rails generate dbt:source
```

##### For Example:

> [!NOTE]
>
> Since the output is as follows, it is recommended that you indent yaml with a tool of your choice.

```yaml
---
version: 2
sources:
- name: dummy
  meta:
    generated_by: activerecord-dbt
  description: |-
    Write a description of the dummy source.
    You can write multiple lines.
  tables:
  - name: ar_internal_metadata
    description: |-
      # Internal Metadata
      By default Rails will store information about your Rails environment and schema
      in an internal table named `ar_internal_metadata`.
    columns:
    - name: key
      description: Key
      tests:
      - unique
      - not_null
    - name: value
      description: Value
    - name: created_at
      description: Created At
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      tests:
      - not_null
  - name: schema_migrations
    description: |-
      # Schema Migrations
      Rails keeps track of which migrations have been committed to the database and
      stores them in a neighboring table in that same database called `schema_migrations`.
    columns:
    - name: version
      description: The version number of the migration.
      tests:
      - unique
      - not_null
  - name: users
    description: User
    loaded_at_field: created_at
    freshness:
      warn_after:
        count: 3
        period: day
      error_after:
        count: 5
        period: day
    columns:
    - name: id
      description: ID
      tests:
      - unique
      - not_null
    - name: created_at
      description: User Created At
      tests:
      - not_null:
          where: id != 1
    - name: updated_at
      description: User Updated At
      tests:
      - not_null
    - name: company_id
      description: Write a description of the users.company_id column.
      tests:
      - relationships:
          to: source('dummy', 'companies')
          field: id
          meta:
            relationship_type: many-to-one

```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
