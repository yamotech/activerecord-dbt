# Change Log

## [Unreleased]

- Fix column order in `stg_*.yml`
- Fix `No matching signature for operator IN for argument types INT64 and {BOOL} at []`
- Changed to be able to exclude specified table names from sources
- Fix `Unrecognized name: None at []`
- Fix `Syntax error: Unexpected keyword GROUP at []`
- Fix `dbt_utils.unique_combination_of_columns`
- Swap `translated_column_name` and `translated_attribute_name`
- Fix `gsub': no implicit conversion of nil into String (TypeError)`
- Update `ActiveRecord::Dbt::Seed::Enum::Yml#before_type_of_cast_column`
- Add the `project_name` to the top of the `description`
- Add `data_type` to enum column

## [0.4.0] - 2024-09-01

- Rename `tests:` to `data_tests:`
- Change output destination from `#{export_directory_path}/*.*` to `#{export_directory_path}/**/*.*`
- Rename `#config` to `#properties`
- Fix `ArgumentError`
- Changed to run in `development` environment only
- Rename `Test` to `DataTest`
- Rename `Factory` to `YmlFactory`

## [0.3.0] - 2024-08-14

- Generate seed enum files for dbt from the specified `TABLE_NAME` and `ENUM_COLUMN_NAME`

## [0.2.0] - 2024-08-03

- Change `meta.column_type` to `data_type`

## [0.1.0] - 2024-07-20

- First release
