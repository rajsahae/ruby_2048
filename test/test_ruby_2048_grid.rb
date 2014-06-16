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

  def test_grid_gives_random_available_tile
    prng = Random.new(0)
    g = Grid.new(:prng => prng)
    c = g.random_cell
    c.x.must_equal(0)
    c.y.must_equal(3)
  end

  def test_grid_moves_tiles_right
    prng = Random.new(0)
    g = Grid.new(:prng => prng)
    g.insert_tile(2, 0, 3)
    g.insert_tile(2, 0, 0)

    g.move_cells(:right)
    fc = g.filled_cells
    p fc
    c1, c2 = fc

    c1.x.must_equal(0)
    c1.y.must_equal(3)
    c1.value.must_equal(4)

    c2.x.must_equal(0)
    c2.y.must_equal(3)
    c2.value.must_equal(2)
  end
  
end
