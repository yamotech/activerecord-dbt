require "zeitwerk"
loader = Zeitwerk::Loader.for_gem_extension(ActiveRecord)
loader.setup

module ActiveRecord
  module Dbt
    # Your code goes here...
  end
end
