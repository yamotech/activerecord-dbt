module Dbt
  module Generators
    class SourceGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_source_file
        create_file "tmp/dbt/src_#{application_name}.yml", <<~RUBY
          # TODO
        RUBY
      end

      private

      def application_name
        Rails.application.class.name.sub(/::Application$/, '').downcase
      end
    end
  end
end
