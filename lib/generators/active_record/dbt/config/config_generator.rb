# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Generators
      class ConfigGenerator < Rails::Generators::Base
        source_root File.expand_path('templates', __dir__)

        def create_source_config_file
          template 'source_config.yml.tt', source_config_path
        end

        def copy_staging_model_sql_tt_file
          copy_file File.expand_path('../staging_model/templates/staging_model.sql.tt', __dir__),
                    'lib/dbt/staging_model.sql.tt'
        end

        private

        def source_config_path
          ActiveRecord::Dbt::Config.instance.source_config_path
        end

        def application_name
          Rails.application.class.name.sub(/::Application$/, '').downcase
        end
      end
    end
  end
end
