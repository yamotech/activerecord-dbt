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
$ bin/rails generate active_record:dbt:initializer
```

configuration | descrption
--------- | ---------
source_config_path | The path to the file that describes the items you want to set in source property. Default is `lib/dbt/source_config.yml`.
data_sync_delayed | Is there a data delay? If set to `true`, `serverity: warn` will be set for `relationships` test. Default is `false`.
logger | Log output destination. Default is `Logger.new('./log/active_record_dbt.log')`.
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
$ bin/rails generate active_record:dbt:config
```

The items that can be set in `sources` and `table_overrides` are listed in [Source properties | dbt Developer Hub](https://docs.getdbt.com/reference/source-properties).


##### sources

Set all items except `tables`.

For example:

```yml
sources:
  name: dummy
  meta:
    generated_by: activerecord-dbt
  description: |-
    Write a description of the 'dummy' source.
    You can write multiple lines.

```

##### table_overrides

Set all items in the `tables` except `name` and `description`.

For example:

```yml
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

##### defaults

Set default values for `name` and `description` of `table`.

In `logical_name` and `description` of `table_descriptions`, `'#{table_name}'` can refer to the table name.
In the `description` of `columns`, you can refer to the table name by `'#{table_name}'` and the column name by `'#{column_name}'`.

For example:

```yml
defaults:
  table_descriptions:
    logical_name: Write a logical_name of the '#{table_name}' table.
    description: Write a description of the '#{table_name}' table.
    columns:
      description: Write a description of the '#{table_name}.#{name}' column.

```

If nothing is set, it works the same as if the following were set.

```yml
defaults:
  table_descriptions:
    logical_name: Write a logical_name of the '#{table_name}' table.
    columns:
      description: Write a description of the '#{table_name}.#{name}' column.

```

##### table_descriptions

Set the `name` and `description` of the `tables`.

configuration | descrption
--------- | ---------
logical_name | Title or one-line description to be output in dbt `description`.
description | Detailed description of `logical_name` to be output in dbt `description`.

For example:

```yml
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

```

##### For Example:

Change the settings according to your environment.

```yml
sources:
  name: dummy
  meta:
    generated_by: activerecord-dbt
  description: |-
    Write a description of the 'dummy' source.
    You can write multiple lines.

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

defaults:
  table_descriptions:
    logical_name: Write a logical_name of the '#{table_name}' table.
    description: Write a description of the '#{table_name}' table.
    columns:
      description: Write a description of the '#{table_name}.#{name}' column.

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

```

#### Generate `tmp/dbt/src_#{source_name}.yml`

```bash
$ bin/rails generate active_record:dbt:source
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
    Write a description of the 'dummy' source.
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
  - name: companies
    description: |-
      # Write a logical_name of the 'companies' table.
      Write a description of the 'companies' table.
    columns:
    - name: id
      description: id
      tests:
      - unique
      - not_null
    - name: name
      description: Write a description of the 'companies.#{name}' column.
      tests:
      - not_null
    - name: establishment_date
      description: Write a description of the 'companies.#{name}' column.
    - name: average_age
      description: Write a description of the 'companies.#{name}' column.
    - name: published
      description: Write a description of the 'companies.#{name}' column.
      tests:
      - not_null
      - accepted_values:
          values:
          - true
          - false
          quote: false
    - name: created_at
      description: Created At
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      tests:
      - not_null
  - name: posts
    description: |-
      # Post
      Write a description of the 'posts' table.
    columns:
    - name: id
      description: ID
      tests:
      - unique
      - not_null
    - name: user_id
      description: User
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: title
      description: Title
    - name: content
      description: Content
    - name: created_at
      description: Post Created At
      tests:
      - not_null
    - name: updated_at
      description: Post Updated At
      tests:
      - not_null
    - name: status
      description: Write a description of the 'posts.#{name}' column.
      tests:
      - accepted_values:
          values:
          - 0
          - 1
          - 2
          quote: false
  - name: posts_tags
    description: |-
      # Write a logical_name of the 'posts_tags' table.
      Write a description of the 'posts_tags' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - post_id
        - tag_id
    columns:
    - name: post_id
      description: post_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'posts')
          field: id
          meta:
            relationship_type: many-to-one
            active_record_dbt_error:
              class: NameError
              message: uninitialized constant PostsTag
    - name: tag_id
      description: tag_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'tags')
          field: id
          meta:
            relationship_type: many-to-one
            active_record_dbt_error:
              class: NameError
              message: uninitialized constant PostsTag
  - name: profiles
    description: |-
      # Write a logical_name of the 'profiles' table.
      Write a description of the 'profiles' table.
    columns:
    - name: id
      description: id
      tests:
      - unique
      - not_null
    - name: user_id
      description: user_id
      tests:
      - unique
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: one-to-one
    - name: first_name
      description: Write a description of the 'profiles.#{name}' column.
      tests:
      - not_null
    - name: last_name
      description: Write a description of the 'profiles.#{name}' column.
      tests:
      - not_null
    - name: created_at
      description: Created At
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      tests:
      - not_null
  - name: relationships
    description: |-
      # Write a logical_name of the 'relationships' table.
      Write a description of the 'relationships' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - follower_id
        - followed_id
    columns:
    - name: id
      description: id
      tests:
      - unique
      - not_null
    - name: follower_id
      description: follower_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: followed_id
      description: followed_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
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
  - name: tags
    description: |-
      # Write a logical_name of the 'tags' table.
      Write a description of the 'tags' table.
    columns:
    - name: id
      description: id
      tests:
      - unique
      - not_null
    - name: name
      description: Write a description of the 'tags.#{name}' column.
      tests:
      - unique
      - not_null
    - name: created_at
      description: Created At
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      tests:
      - not_null
  - name: user_tags
    description: |-
      # Write a logical_name of the 'user_tags' table.
      Write a description of the 'user_tags' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - user_id
        - tag_id
    columns:
    - name: id
      description: id
      tests:
      - unique
      - not_null
    - name: user_id
      description: user_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: tag_id
      description: tag_id
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'tags')
          field: id
          meta:
            relationship_type: many-to-one
    - name: created_at
      description: Created At
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      tests:
      - not_null
  - name: users
    description: |-
      # User
      Write a description of the 'users' table.
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
      description: company_id
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
