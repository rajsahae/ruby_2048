require 'minitest_helper'

class TestRuby2048 < MiniTest::Unit::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Ruby2048::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
