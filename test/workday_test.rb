require "test_helper"

class WorkdayTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Workday::VERSION
  end
end
