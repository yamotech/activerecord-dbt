# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module DwhPlatform
        extend ActiveRecord::Dbt::RequiredMethods

        define_required_methods :source_config_path

        def dwh_platform=(dwh_platform)
          @dwh_platform = validate_dwh_platform(dwh_platform)
        end

        def dwh_platform
          @dwh_platform || (raise DwhPlatformIsNullError, "'dwh_platform' is required in '#{source_config_path}'.")
        end

        private

        def validate_dwh_platform(dwh_platform)
          return dwh_platform if selectable_dwh_platforms.include?(dwh_platform)

          raise DoesNotExistOnTheDwhPlatformError, [
            "'#{dwh_platform}' does not exist on the DWH platform.",
            "Please specify one of the following: #{selectable_dwh_platforms.join(', ')}."
          ].join(' ')
        end

        def selectable_dwh_platforms
          @selectable_dwh_platforms ||= ActiveRecord::Dbt::DataType::Mapper::RUBY_TO_DWH_PLATFORM_TYPE_MAP.keys
        end

        class DoesNotExistOnTheDwhPlatformError < StandardError; end
        class DwhPlatformIsNullError < StandardError; end
      end
    end
  end
end
