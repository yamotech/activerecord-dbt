# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Configuration
      module Logger
        DEFAULT_LOG_FILE_PATH = './log/active_record_dbt.log'
        EXCLUDE_EXCEPTION_CLASS_NAMES = %w[ArInternalMetadatum SchemaMigration].freeze

        attr_writer :logger

        def logger
          @logger ||= ::Logger.new(DEFAULT_LOG_FILE_PATH)
        end

        def add_log(class_name, exception)
          return if include_exception_class_names?(exception)

          logger.info(class_name) { format_log(exception) }
        end

        private

        def include_exception_class_names?(exception)
          exception.instance_of?(NameError) &&
            EXCLUDE_EXCEPTION_CLASS_NAMES.include?(exception.name.to_s)
        end

        def format_log(exception)
          {
            exception: [
              exception.class,
              exception.message
            ],
            exception_backtrace: exception.backtrace.first(5)
          }.to_json
        end
      end
    end
  end
end
