#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

class TestRuby2048Game < MiniTest::Unit::TestCase
  include Ruby2048

  def test_it_takes_initial_tiles
    r2048 = Game.new(:tiles => 4)
    r2048.num_start_tiles.must_equal(4)
  end

  def test_default_game_has_2_start_tiles
    r2048 = Game.new
    r2048.num_start_tiles.must_equal(2)
  end

  def test_new_game_takes_optional_seed
    r2048 = Game.new(:seed => 0)
    r2048.seed.must_equal(0)
  end

  def test_game_returns_random_tiles
    r2048 = Game.new(:seed => 0)

    10.times do |n|
      tile = r2048.next_tile

      if n == 8
        tile.must_equal(4)
      else
        tile.must_equal(2)
      end

    end
  end

  def test_it_has_a_grid
    r2048 = Game.new(:seed => 0)
    r2048.grid.must_be_kind_of(Grid)
  end
end
