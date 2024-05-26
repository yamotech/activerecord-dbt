module Dbt
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer_file
        copy_file "dbt.rb", "config/initializers/dbt.rb"
      end
    end
  end
end
