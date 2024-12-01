# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class EnumGenerator < Rails::Generators::NamedBase
        source_root File.expand_path('templates', __dir__)

        argument :enum_column_name, type: :string, default: nil

        def create_enum_seed_csv_file
          create_file csv.export_path, csv.dump
        end

        def create_enum_seed_yml_file
          create_file yml.export_path, yml.dump
        end

        private

        def csv
          @csv ||= ActiveRecord::Dbt::Seed::Enum::Csv.new(name, enum_column_name)
        end

        def yml
          @yml ||= ActiveRecord::Dbt::Factory::Enum::YmlFactory.build(name, enum_column_name)
        end
      end
    end
  end
end
