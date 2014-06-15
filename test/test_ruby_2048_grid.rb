#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

class TestRuby2048Game < MiniTest::Unit::TestCase
  include Ruby2048

  def test_grid_has_a_default_size
    g = Grid.new
    g.size.must_equal(4)
  end

  def test_grid_has_a_default_prng
    g = Grid.new
    g.prng.must_be_kind_of(Random)
  end

  def test_grid_takes_optional_size
    g = Grid.new(:size => 5)
    g.size.must_equal(5)
  end

  def test_grid_takes_optional_prng
    prng = Random.new(0)
    g = Grid.new(:prng => prng)
    g.prng.must_equal(prng)
  end
end
