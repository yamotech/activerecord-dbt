# ActiveRecord::Dbt

[![Gem Version](https://badge.fury.io/rb/activerecord-dbt.svg)](https://badge.fury.io/rb/activerecord-dbt)
[![Maintainability](https://api.codeclimate.com/v1/badges/ef9a0a71c73dae7b8156/maintainability)](https://codeclimate.com/github/yamotech/activerecord-dbt/maintainability)
[![Ruby CI](https://github.com/yamotech/activerecord-dbt/actions/workflows/ruby-ci.yml/badge.svg)](https://github.com/yamotech/activerecord-dbt/actions/workflows/ruby-ci.yml)

`ActiveRecord::Dbt` generates [dbt](https://www.getdbt.com/) files from the information of the database connected via ActiveRecord.

Currently, it can generate `yaml` files for `sources` and `models` files for `staging`.

## Installation

To install `activerecord-dbt`, add this line to your application's Gemfile:

```ruby
gem 'activerecord-dbt'
```

Since it is only used in the development environment, it is recommended to add it to the development group:

```ruby
group :development do
  gem 'activerecord-dbt'
end
```

Then run:

```bash
$ bundle
```

Alternatively, you can install it manually by running:

```bash
$ gem install activerecord-dbt
```

## Usage

### Configuration

#### ActiveRecord::Dbt Configuration

Create an initializer file for dbt:

```bash
$ bin/rails generate active_record:dbt:initializer
```

This will generate the `config/initializers/dbt.rb` file.

Configuration | Description
--------- | ---------
config_directory_path | The path to the directory where files generated by `bin/rails generate active_record:dbt:*` are stored. The default is `lib/dbt`.
export_directory_path | The path to the directory where configuration files are stored. The default is `doc/dbt`.
dwh_platform | Specify the data warehouse platform to which dbt connects. The default is `bigquery`.
data_sync_delayed | Indicates whether there is a data delay. If set to `true`, `severity: warn` is applied to the `relationships` test. The default is `false`.
logger | The destination for log output. The default is `Logger.new('./log/active_record_dbt.log')`.
used_dbt_package_names | An array of `dbt` package names to use.

List of platforms that can currently be set with `dwh_platform`.

Data Warehouse Platform | Link
--------- | ---------
bigquery | [BigQuery enterprise data warehouse | Google Cloud](https://cloud.google.com/bigquery?hl=en)
postgres | [PostgreSQL: The world's most advanced open source database](https://www.postgresql.org/)
redshift | [Cloud Data Warehouse - Amazon Redshift - AWS](https://aws.amazon.com/redshift/)
snowflake | [The Snowflake AI Data Cloud - Mobilize Data, Apps, and AI](https://www.snowflake.com/en/)
spark | [Apache Spark™ - Unified Engine for large-scale data analytics](https://spark.apache.org/)

List of packages that can currently be set with `used_dbt_package_names`.

dbt Package Name | Link
--------- | ---------
dbt-labs/dbt-utils | [dbt-labs/dbt-utils: Utility functions for dbt projects.](https://github.com/dbt-labs/dbt-utils)
datnguye/dbterd | [datnguye/dbterd: Generate the ERD as a code from dbt artifacts](https://github.com/datnguye/dbterd)

Example:

Adjust the settings according to your environment.

```ruby
# frozen_string_literal: true

require 'active_record/dbt'

ActiveRecord::Dbt.configure do |c|
  c.config_directory_path = 'lib/dbt'
  c.export_directory_path = 'doc/dbt'
  c.data_sync_delayed = false
  c.used_dbt_package_names = [
    'dbt-labs/dbt_utils',
    'datnguye/dbterd'
  ]
end

```

#### Create Configuration Files

Create configuration files for dbt:

```bash
$ bin/rails generate active_record:dbt:config
```

This will create the following files.

File | Description
--------- | ---------
`#{config_directory_path}/source_config.yml` | Used to generate `#{export_directory_path}/src_#{source_name}.yml`.
`#{config_directory_path}/staging_model.sql.tt` | Used to generate `#{export_directory_path}/stg_#{source_name}__#{table_name}.sql`.

### Generate dbt Source File

#### dbt Source Configuration

In the `#{config_directory_path}/source_config.yml` file, describe the properties you want to set for the source.
You can configure `sources`, `table_overrides`, `defaults`, and `table_descriptions` in this file.

The available properties for `sources` and `table_overrides` are detailed in [Source properties | dbt Developer Hub](https://docs.getdbt.com/reference/source-properties).

##### sources

Set all properties except for `tables`.

Example:

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

Set all properties for `tables` except for `name` and `description`.

Example:

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

Set default values for the `name` and `description` of `tables`.

In `logical_name` and `description` of `table_descriptions`, you can refer to the table name with `{{ table_name }}`.
In the `description` of `columns`, you can refer to the table name with `{{ table_name }}` and the column name with `{{ column_name }}`.

Example:

```yml
defaults:
  table_descriptions:
    logical_name: Write a logical_name of the '{{ table_name }}' table.
    columns:
      description: Write a description of the '{{ table_name }}.{{ column_name }}' column.

```

If nothing is set, it defaults to the following:

```yml
defaults:
  table_descriptions:
    logical_name: Write a logical_name of the '{{ table_name }}' table.
    columns:
      description: Write a description of the '{{ table_name }}.{{ column_name }}' column.

```

##### table_descriptions

Set the `name` and `description` for `tables`.

Configuration | Description
--------- | ---------
logical_name | A title or one-line description to be output in the dbt `description`.
description | A detailed description of `logical_name` to be output in the dbt `description`.

Example:

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

##### Example:

Adjust the settings according to your environment.

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
    logical_name: Write a logical_name of the '{{ table_name }}' table.
    columns:
      description: Write a description of the '{{ table_name }}.{{ column_name }}' column.

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

#### Generate `#{export_directory_path}/src_#{source_name}.yml`

Generate a source file for dbt:

```bash
$ bin/rails generate active_record:dbt:source
```

Generate `#{export_directory_path}/src_#{source_name}.yml`.

##### Example:

> [!NOTE]
>
> The output will be as shown below. It is recommended to indent the YAML file with a tool of your choice.

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
      data_type: string
      tests:
      - unique
      - not_null
    - name: value
      description: Value
      data_type: string
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
      tests:
      - not_null
  - name: companies
    description: Write a logical_name of the 'companies' table.
    columns:
    - name: id
      description: id
      data_type: int64
      tests:
      - unique
      - not_null
    - name: name
      description: Write a description of the 'companies.name' column.
      data_type: string
      tests:
      - not_null
    - name: establishment_date
      description: Write a description of the 'companies.establishment_date' column.
      data_type: string
    - name: average_age
      description: Write a description of the 'companies.average_age' column.
      data_type: float64
    - name: published
      description: Write a description of the 'companies.published' column.
      data_type: bool
      tests:
      - not_null
      - accepted_values:
          values:
          - true
          - false
          quote: false
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
      tests:
      - not_null
  - name: posts
    description: Post
    columns:
    - name: id
      description: ID
      data_type: int64
      tests:
      - unique
      - not_null
    - name: user_id
      description: User
      data_type: int64
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: title
      description: Title
      data_type: string
    - name: content
      description: Content
      data_type: string
    - name: created_at
      description: Post Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Post Updated At
      data_type: datetime
      tests:
      - not_null
    - name: status
      description: Write a description of the 'posts.status' column.
      data_type: int64
      tests:
      - accepted_values:
          values:
          - 0
          - 1
          - 2
          quote: false
  - name: posts_tags
    description: Write a logical_name of the 'posts_tags' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - post_id
        - tag_id
    columns:
    - name: post_id
      description: post_id
      data_type: int64
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
      data_type: int64
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
    description: Write a logical_name of the 'profiles' table.
    columns:
    - name: id
      description: id
      data_type: int64
      tests:
      - unique
      - not_null
    - name: user_id
      description: user_id
      data_type: int64
      tests:
      - unique
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: one-to-one
    - name: first_name
      description: Write a description of the 'profiles.first_name' column.
      data_type: string
      tests:
      - not_null
    - name: last_name
      description: Write a description of the 'profiles.last_name' column.
      data_type: string
      tests:
      - not_null
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
      tests:
      - not_null
  - name: relationships
    description: Write a logical_name of the 'relationships' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - follower_id
        - followed_id
    columns:
    - name: id
      description: id
      data_type: int64
      tests:
      - unique
      - not_null
    - name: follower_id
      description: follower_id
      data_type: int64
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: followed_id
      description: followed_id
      data_type: int64
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
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
      data_type: string
      tests:
      - unique
      - not_null
  - name: tags
    description: Write a logical_name of the 'tags' table.
    columns:
    - name: id
      description: id
      data_type: int64
      tests:
      - unique
      - not_null
    - name: name
      description: Write a description of the 'tags.name' column.
      data_type: string
      tests:
      - unique
      - not_null
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
      tests:
      - not_null
  - name: user_tags
    description: Write a logical_name of the 'user_tags' table.
    tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
        - user_id
        - tag_id
    columns:
    - name: id
      description: id
      data_type: int64
      tests:
      - unique
      - not_null
    - name: user_id
      description: user_id
      data_type: int64
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'users')
          field: id
          meta:
            relationship_type: many-to-one
    - name: tag_id
      description: tag_id
      data_type: int64
      tests:
      - not_null
      - relationships:
          to: source('dummy', 'tags')
          field: id
          meta:
            relationship_type: many-to-one
    - name: created_at
      description: Created At
      data_type: datetime
      tests:
      - not_null
    - name: updated_at
      description: Updated At
      data_type: datetime
      tests:
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
      data_type: int64
      tests:
      - unique
      - not_null
    - name: created_at
      description: User Created At
      data_type: datetime
      tests:
      - not_null:
          where: id != 1
    - name: updated_at
      description: User Updated At
      data_type: datetime
      tests:
      - not_null
    - name: company_id
      description: company_id
      data_type: int64
      tests:
      - relationships:
          to: source('dummy', 'companies')
          field: id
          meta:
            relationship_type: many-to-one

```

### Generate dbt Staging Files

#### dbt Staging Configuration

In the `#{config_directory_path}/staging_model.sql.tt` file, write the SQL template for the `staging` model you want to create.
You can use `sql.source_name`, `sql.table_name`, `sql.select_column_names`, `sql.primary_key_eql_id?`, and `sql.rename_primary_id` within this file.

Example:

```sql
with

source as (

    select * from {{ source('<%= sql.source_name %>', '<%= sql.table_name %>') }}

),

renamed as (

    select

        <%- sql.select_column_names.each_with_index do |(column_type, columns), column_type_index| -%>
          -- <%= column_type %>
          <%- columns.each_with_index do |column, column_index| -%>
          <%- is_rename_primary_id = sql.primary_key_eql_id? && sql.primary_key?(column.name) -%>
          <%- is_last_column = column_type_index == sql.select_column_names.size - 1 && column_index == columns.size - 1 -%>
          <%= is_rename_primary_id ? "id as #{sql.rename_primary_id}" : column.name %><% unless is_last_column -%>,<%- end %>
          <%- if column_type_index != sql.select_column_names.size - 1 && column_index == columns.size - 1 -%>

          <%- end -%>
          <%- end -%>
        <%- end -%>

    from source

)

select * from renamed

```

Different Pattern:

```sql
#standardSQL

with source as (
  select
    <%- if sql.primary_key_eql_id? -%>
    id as <%= sql.rename_primary_id %>
    , * except(id)
    <%- else -%>
    *
    <%- end -%>
  from {{ source('<%= sql.source_name %>', '<%= sql.table_name %>') }}
)

, final as (
  select
  <%- sql.select_column_names.each_with_index do |(column_type, columns), column_type_index| -%>
    -- <%= column_type %>
    <%- columns.each_with_index do |column, column_index| -%>
    <% unless column_type_index == 0 && column_index == 0 -%>, <%- end %><%= (sql.primary_key_eql_id? && sql.primary_key?(column.name) ? sql.rename_primary_id : column.name) %>
    <%- if column_type_index != sql.select_column_names.size - 1 && column_index == columns.size - 1 -%>

    <%- end -%>
    <%- end -%>
  <%- end -%>
  from source
)

select
  *
from final

```

#### Generate dbt Staging Files

Generate staging model files for dbt:

```bash
$ bin/rails generate active_record:dbt:staging_model TABLE_NAME
```

Generate staging model files for dbt that reference the specified `TABLE_NAME`.

File | Description
--------- | ---------
`#{export_directory_path}/stg_#{source_name}__#{table_name}.sql` | Staging model file for dbt.
`#{export_directory_path}/stg_#{source_name}__#{table_name}.yml` | Staging model documentation file for dbt.

Example:

```bash
$ bin/rails generate active_record:dbt:staging_model profiles
```

##### Generate `#{export_directory_path}/stg_#{source_name}__#{table_name}.sql`

Example:

```sql
with

source as (

    select * from {{ source('dummy', 'profiles') }}

),

renamed as (

    select

          -- ids
          id as profile_id,
          user_id,

          -- strings
          first_name,
          last_name,

          -- datetimes
          created_at,
          updated_at

    from source

)

select * from renamed

```

Different Pattern:

```sql
#standardSQL

with source as (
  select
    id as profile_id
    , * except(id)
  from {{ source('dummy', 'profiles') }}
)

, final as (
  select
    -- ids
    profile_id
    , user_id

    -- strings
    , first_name
    , last_name

    -- datetimes
    , created_at
    , updated_at
  from source
)

select
  *
from final

```

##### Generate `#{export_directory_path}/stg_#{source_name}__#{table_name}.yml`

Example:

```yaml
---
version: 2
models:
- name: stg_dummy__profiles
  description: Write a logical_name of the 'profiles' table.
  columns:
  - name: profile_id
    description: profile_id
    meta:
      column_type: integer
    tests:
    - unique
    - not_null
    - relationships:
        to: source('dummy', 'profiles')
        field: id
        meta:
          relationship_type: one-to-one
  - name: user_id
    description: user_id
    meta:
      column_type: integer
    tests:
    - unique
    - not_null
    - relationships:
        to: source('dummy', 'users')
        field: id
        meta:
          relationship_type: one-to-one
  - name: first_name
    description: Write a description of the 'profiles.first_name' column.
    meta:
      column_type: string
    tests:
    - not_null
  - name: last_name
    description: Write a description of the 'profiles.last_name' column.
    meta:
      column_type: string
    tests:
    - not_null
  - name: created_at
    description: Created At
    meta:
      column_type: datetime
    tests:
    - not_null
  - name: updated_at
    description: Updated At
    meta:
      column_type: datetime
    tests:
    - not_null

```

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
