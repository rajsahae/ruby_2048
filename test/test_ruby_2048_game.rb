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

      c1, c2 = fc

      c1.row.must_equal(0)
      c1.col.must_equal(0)
      c1.value.must_equal(2)

      c2.row.must_equal(3)
      c2.col.must_equal(0)
      c2.value.must_equal(2)
    end
=begin
    it "lets you make moves" do
      @g.must_respond_to(:move)

      @g = Game.new(:seed => 0)
      @g.move(:down)
      fc = @g.grid.filled_cells
      p fc
      c1, c2 = fc

      c1.x.must_equal(0)
      c1.y.must_equal(3)
      c1.value.must_equal(4)

      c2.x.must_equal(0)
      c2.y.must_equal(3)
      c2.value.must_equal(2)

      @g = Game.new(:seed => 0)
      @g.move(:right)
      p fc
      fc = @g.grid.filled_cells
      c1, c2, c3 = fc

      c1.x.must_equal(3)
      c1.y.must_equal(0)
      c1.value.must_equal(2)

      c2.x.must_equal(3)
      c2.y.must_equal(3)
      c2.value.must_equal(2)

      c2.x.must_equal(2)
      c2.y.must_equal(2)
      c2.value.must_equal(2)

      @g = Game.new(:seed => 0)
      @g.move(:up)
      fc = @g.grid.filled_cells
      p fc
      c1, c2 = fc

      c1.x.must_equal(0)
      c1.y.must_equal(0)
      c1.value.must_equal(4)

      c2.x.must_equal(0)
      c2.y.must_equal(3)
      c2.value.must_equal(2)

      @g = Game.new(:seed => 0)
      @g.move(:left)
      fc = @g.grid.filled_cells
      p fc
      c1, c2 = fc

      c1.x.must_equal(0)
      c1.y.must_equal(0)
      c1.value.must_equal(2)

      c2.x.must_equal(0)
      c2.y.must_equal(3)
      c2.value.must_equal(2)
    end
=end
  end
end
