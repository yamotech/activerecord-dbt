require "test_helper"

class ActiveRecord::DbtTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert ActiveRecord::Dbt::VERSION
  end
end
