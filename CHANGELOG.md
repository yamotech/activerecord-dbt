# Change Log

## [Unreleased]

- Rename `tests:` to `data_tests:`
- Change output destination from `#{export_directory_path}/*.*` to `#{export_directory_path}/**/*.*`
- Rename `#config` to `#properties`
- Fix `ArgumentError`
- Changed to run in `development` environment only
- Rename `Test` to `DataTest`

## [0.3.0] - 2024-08-14

- Generate seed enum files for dbt from the specified `TABLE_NAME` and `ENUM_COLUMN_NAME`

## [0.2.0] - 2024-08-03

- Change `meta.column_type` to `data_type`

## [0.1.0] - 2024-07-20

- First release
