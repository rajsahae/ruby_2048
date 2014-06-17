#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'
require 'pp'

module Ruby2048

  describe Grid do

    before do 
      @prng = Random.new(0)
      @g = Grid.new(:prng => @prng)
    end

    it "has a default size" do
      @g.size.must_equal(4)
    end

    it "has a default psuedo random number generator" do
      @g.prng.must_be_kind_of(Random)
    end

    it "takes an optional size" do
      g = Grid.new(:size => 5)
      g.size.must_equal(5)
    end

    it "takes an optional prng" do
      @g.prng.must_equal(@prng)
    end

    it "gives a random available tile" do
      c = @g.random_cell
      c.row.must_equal(3)
      c.col.must_equal(0)
    end

    it "has an array representation" do
      grid = [
        [2, nil, nil, 2],
        [nil, 4, nil, nil],
        [nil, nil, 8, nil],
        [nil, nil, nil, 16]
      ]
        
      @g.insert_tile(2, 0, 3)
      @g.insert_tile(2, 0, 0)
      @g.insert_tile(4, 1, 1)
      @g.insert_tile(8, 2, 2)
      @g.insert_tile(16, 3, 3)
      @g.to_a.must_equal(grid)
    end

    it "shifts tiles left" do
      @g.insert_tile(2, 0, 3)
      @g.insert_tile(2, 3, 3)

      pp @g.cells.to_a
      @g.send(:shift_cells, :left)
      pp @g.cells.to_a

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 0))
      fc.must_include(Cell.new(2, 3, 0))
    end

    it "shifts staggered tiles left" do
      @g.insert_tile(4, 0, 3)
      @g.insert_tile(2, 0, 1)

      @g.send(:shift_cells, :left)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 0))
      fc.must_include(Cell.new(4, 0, 1))
    end

    it "shifts tiles right" do
      @g.insert_tile(2, 0, 0)
      @g.insert_tile(4, 2, 0)

      @g.send(:shift_cells, :right)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 3))
      fc.must_include(Cell.new(4, 2, 3))
    end

    it "shifts staggered tiles right" do
      @g.insert_tile(2, 0, 0)
      @g.insert_tile(4, 0, 2)

      @g.send(:shift_cells, :right)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 2))
      fc.must_include(Cell.new(4, 0, 3))
    end

    it "shifts tiles up" do
      @g.insert_tile(2, 1, 3)
      @g.insert_tile(2, 2, 2)

      @g.send(:shift_cells, :up)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 2))
      fc.must_include(Cell.new(2, 0, 3))
    end

    it "shifts staggered tiles up" do
      @g.insert_tile(2, 1, 3)
      @g.insert_tile(4, 3, 3)

      @g.send(:shift_cells, :up)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 0, 3))
      fc.must_include(Cell.new(4, 1, 3))
    end

    it "shifts tiles down" do
      @g.insert_tile(2, 1, 1)
      @g.insert_tile(2, 2, 0)

      @g.send(:shift_cells, :down)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 3, 1))
      fc.must_include(Cell.new(2, 3, 0))
    end

    it "shifts staggered tiles down" do
      @g.insert_tile(2, 1, 1)
      @g.insert_tile(4, 2, 1)

      @g.send(:shift_cells, :down)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 2, 1))
      fc.must_include(Cell.new(4, 3, 1))
    end

    it "combines tiles left" do
      assert false
    end

    it "combines tiles right" do
      assert false
    end

    it "combines tiles up" do
      assert false
    end

    it "combines tiles down" do
      assert false
    end
  end
end
