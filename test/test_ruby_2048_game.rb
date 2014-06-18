#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

module Ruby2048
  describe Game do

    before do
      @g = Game.new(:seed => 0)
    end

    it "takes initial tiles" do
      g = Game.new(:tiles => 4)
      g.start_tiles.must_equal(4)
    end

    it "has 2 start tiles for the default game" do
      @g.start_tiles.must_equal(2)
    end

    it "takes an optional seed for a new game" do
      @g.seed.must_equal(0)
    end

    it "generates a random tile value" do
      10.times do |n|
        tile = @g.next_tile

        if n == 5
          tile.must_equal(4)
        else
          tile.must_equal(2)
        end

      end
    end

    it "has a grid" do
      @g.grid.must_be_kind_of(Grid)
    end

    it "adds start tiles to a new game" do
      fc = @g.grid.filled_cells
      fc.count.must_equal(2)
      ac = @g.grid.available_cells
      ac.count.must_equal(14)

      fc.must_include(Cell.new(0, 0, 2))
      fc.must_include(Cell.new(3, 0, 2))
    end

    it "adds a random tile to the grid after every move" do
      @g.move(:down)
      fc = @g.grid.filled_cells

      fc.size.must_equal(2)
      fc.must_include(Cell.new(3, 0, 4))
      fc.must_include(Cell.new(0, 3, 2))
    end

    it "knows when the game is over" do
      @g.over?.must_equal(false)

      @g.grid.insert_tile(0, 0, 2)
      @g.grid.insert_tile(0, 1, 4)
      @g.grid.insert_tile(0, 2, 2)
      @g.grid.insert_tile(0, 3, 4)

      @g.grid.insert_tile(1, 0, 4)
      @g.grid.insert_tile(1, 1, 2)
      @g.grid.insert_tile(1, 2, 4)
      @g.grid.insert_tile(1, 3, 2)

      @g.grid.insert_tile(2, 0, 2)
      @g.grid.insert_tile(2, 1, 4)
      @g.grid.insert_tile(2, 2, 2)
      @g.grid.insert_tile(2, 3, 4)

      @g.grid.insert_tile(3, 0, 4)
      @g.grid.insert_tile(3, 1, 2)
      @g.grid.insert_tile(3, 2, 4)
      @g.grid.insert_tile(3, 3, 2)

      @g.over?.must_equal(true)
    end
  end
end
