# frozen_string_literal: true

require_relative 'lib/active_record/dbt/version'

Gem::Specification.new do |spec|
  spec.name        = 'activerecord-dbt'
  spec.version     = ActiveRecord::Dbt::VERSION
  spec.authors     = ['yamotech']
  spec.email       = ['nothings.2c9@gmail.com']
  spec.homepage    = 'https://github.com/yamotech/activerecord-dbt'
  spec.summary     = 'Generate dbt files from the information of the database connected by ActiveRecord.'
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.required_ruby_version = '>= 3.0'

  spec.add_dependency 'activerecord', '>= 7.0'
  spec.add_dependency 'activesupport', '>= 7.0'
  spec.add_dependency 'zeitwerk', '>= 2.6'
end
