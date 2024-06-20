# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem_extension(ActiveRecord)
loader.setup

module ActiveRecord
  module Dbt
    def self.configure
      yield config = ActiveRecord::Dbt::Config.instance

      config
    end

    class Error < StandardError; end
  end
end
