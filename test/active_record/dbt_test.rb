# frozen_string_literal: true

require 'test_helper'

module ActiveRecord
  class DbtTest < ActiveSupport::TestCase
    test 'it has a version number' do
      assert ActiveRecord::Dbt::VERSION
    end
  end
end
