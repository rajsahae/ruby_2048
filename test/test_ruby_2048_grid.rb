#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

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
        
      @g.insert_tile(0, 3, 2)
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(2, 2, 8)
      @g.insert_tile(3, 3, 16)
      @g.to_a.must_equal(grid)
    end

    it "shifts tiles left" do
      @g.insert_tile(0, 3, 2)
      @g.insert_tile(3, 3, 2)

      @g.send(:shift_cells, :left)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 0, 2))
      fc.must_include(Cell.new(3, 0, 2))
    end

    it "shifts staggered tiles left" do
      @g.insert_tile(0, 3, 4)
      @g.insert_tile(0, 1, 2)

      @g.send(:shift_cells, :left)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 0, 2))
      fc.must_include(Cell.new(0, 1, 4))
    end

    it "shifts tiles right" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(2, 0, 4)

      @g.send(:shift_cells, :right)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 3, 2))
      fc.must_include(Cell.new(2, 3, 4))
    end

    it "shifts staggered tiles right" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 2, 4)

      @g.send(:shift_cells, :right)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 2, 2))
      fc.must_include(Cell.new(0, 3, 4))
    end

    it "shifts tiles up" do
      @g.insert_tile(1, 3, 2)
      @g.insert_tile(2, 2, 2)

      @g.send(:shift_cells, :up)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 2, 2))
      fc.must_include(Cell.new(0, 3, 2))
    end

    it "shifts staggered tiles up" do
      @g.insert_tile(1, 3, 2)
      @g.insert_tile(3, 3, 4)

      @g.send(:shift_cells, :up)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(0, 3, 2))
      fc.must_include(Cell.new(1, 3, 4))
    end

    it "shifts tiles down" do
      @g.insert_tile(1, 1, 2)
      @g.insert_tile(2, 0, 2)

      @g.send(:shift_cells, :down)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(3, 1, 2))
      fc.must_include(Cell.new(3, 0, 2))
    end

    it "shifts staggered tiles down" do
      @g.insert_tile(1, 1, 2)
      @g.insert_tile(2, 1, 4)

      @g.send(:shift_cells, :down)

      fc = @g.filled_cells
      fc.size.must_equal(2)
      fc.must_include(Cell.new(2, 1, 2))
      fc.must_include(Cell.new(3, 1, 4))
    end

    it "combines tiles left" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 1, 2)
      @g.insert_tile(0, 2, 2)
      @g.insert_tile(1, 0, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(1, 2, 2)
      @g.insert_tile(3, 1, 2)

      @g.combine_cells(:left)

      fc = @g.filled_cells
      fc.size.must_equal(5)
      fc.must_include(Cell.new(0, 0, 4))
      fc.must_include(Cell.new(0, 1, 2))
      fc.must_include(Cell.new(1, 0, 8))
      fc.must_include(Cell.new(1, 1, 2))
      fc.must_include(Cell.new(3, 0, 2))
    end

    it "combines tiles right" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 1, 2)
      @g.insert_tile(0, 2, 2)
      @g.insert_tile(1, 0, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(1, 2, 2)
      @g.insert_tile(3, 1, 2)

      @g.combine_cells(:right)

      fc = @g.filled_cells
      fc.size.must_equal(5)
      fc.must_include(Cell.new(0, 2, 2))
      fc.must_include(Cell.new(0, 3, 4))
      fc.must_include(Cell.new(1, 2, 8))
      fc.must_include(Cell.new(1, 3, 2))
      fc.must_include(Cell.new(3, 3, 2))
    end

    it "combines tiles up" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(1, 0, 2)
      @g.insert_tile(2, 0, 2)
      @g.insert_tile(0, 1, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(2, 1, 2)
      @g.insert_tile(3, 1, 2)

      @g.combine_cells(:up)

      fc = @g.filled_cells
      fc.size.must_equal(4)
      fc.must_include(Cell.new(0, 0, 4))
      fc.must_include(Cell.new(1, 0, 2))
      fc.must_include(Cell.new(0, 1, 8))
      fc.must_include(Cell.new(1, 1, 4))
    end

    it "combines tiles down" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(1, 0, 2)
      @g.insert_tile(2, 0, 2)
      
      @g.insert_tile(0, 1, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(2, 1, 2)
      @g.insert_tile(3, 1, 2)

      @g.combine_cells(:down)

      fc = @g.filled_cells
      fc.size.must_equal(4)
      fc.must_include(Cell.new(3, 0, 4))
      fc.must_include(Cell.new(2, 0, 2))
      fc.must_include(Cell.new(3, 1, 4))
      fc.must_include(Cell.new(2, 1, 8))
    end

    it "combining tiles returns the combined score" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(1, 0, 2)
      @g.insert_tile(2, 0, 2)
      
      @g.insert_tile(0, 1, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(2, 1, 2)
      @g.insert_tile(3, 1, 2)

      @g.combine_cells(:down).must_equal(16)
    end

    it "does a full round of combines correctly" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 1, 2)
      @g.insert_tile(0, 2, 4)
      @g.insert_tile(0, 3, 16)

      @g.insert_tile(1, 0, 4)
      @g.insert_tile(1, 1, 4)
      @g.insert_tile(1, 2, 16)
      @g.insert_tile(1, 3, 2)

      @g.insert_tile(2, 0, 4)
      @g.insert_tile(2, 1, 4)
      @g.insert_tile(2, 2, 8)
      @g.insert_tile(2, 3, 8)

      @g.insert_tile(3, 0, 2)
      @g.insert_tile(3, 1, 4)
      @g.insert_tile(3, 2, 32)
      @g.insert_tile(3, 3, 64)

      after_left = [
        [4, 4, 16, nil],
        [8, 16, 2, nil],
        [8, 16, nil, nil],
        [2, 4, 32, 64]
      ]

      @g.combine_cells(:left)
      @g.to_a.must_equal(after_left)

      after_down = [
        [nil, nil, nil, nil],
        [4, 4, 16, nil],
        [16, 32, 2, nil],
        [2, 4, 32, 64]
      ]

      @g.combine_cells(:down)
      @g.to_a.must_equal(after_down)

      after_right = [
        [nil, nil, nil, nil],
        [nil, nil, 8, 16],
        [nil, 16, 32, 2],
        [2, 4, 32, 64]
      ]

      @g.combine_cells(:right)
      @g.to_a.must_equal(after_right)

      after_up = [
        [2, 16, 8, 16],
        [nil, 4, 64, 2],
        [nil, nil, nil, 64],
        [nil, nil, nil, nil]
      ]

      @g.combine_cells(:up)
      @g.to_a.must_equal(after_up)
    end

    it "raises an error if you try to insert a tile out of bounds" do
      lambda { @g.insert_tile(4, 1, nil) }.must_raise(ArgumentError)
      lambda { @g.insert_tile(1, 4, nil) }.must_raise(ArgumentError)
      lambda { @g.insert_tile(4, 4, nil) }.must_raise(ArgumentError)
      lambda { @g.insert_tile(1, -1, nil) }.must_raise(ArgumentError)
      lambda { @g.insert_tile(-1, 1, nil) }.must_raise(ArgumentError)
      lambda { @g.insert_tile(1, 1, nil) }.must_be_silent
    end

    it "knows when a sparse board has moves available" do
      @g.moves_available?.must_equal(true)
    end

    it "knows when a full board has moves available" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 1, 4)
      @g.insert_tile(0, 2, 2)
      @g.insert_tile(0, 3, 4)

      @g.insert_tile(1, 0, 4)
      @g.insert_tile(1, 1, 2)
      @g.insert_tile(1, 2, 2)
      @g.insert_tile(1, 3, 2)

      @g.insert_tile(2, 0, 2)
      @g.insert_tile(2, 1, 4)
      @g.insert_tile(2, 2, 8)
      @g.insert_tile(2, 3, 8)

      @g.insert_tile(3, 0, 4)
      @g.insert_tile(3, 1, 2)
      @g.insert_tile(3, 2, 4)
      @g.insert_tile(3, 3, 2)

      @g.moves_available?.must_equal(true)
    end

    it "knows when the board has no moves available" do
      @g.insert_tile(0, 0, 2)
      @g.insert_tile(0, 1, 4)
      @g.insert_tile(0, 2, 2)
      @g.insert_tile(0, 3, 4)

      @g.insert_tile(1, 0, 4)
      @g.insert_tile(1, 1, 2)
      @g.insert_tile(1, 2, 4)
      @g.insert_tile(1, 3, 2)

      @g.insert_tile(2, 0, 2)
      @g.insert_tile(2, 1, 4)
      @g.insert_tile(2, 2, 2)
      @g.insert_tile(2, 3, 4)

      @g.insert_tile(3, 0, 4)
      @g.insert_tile(3, 1, 2)
      @g.insert_tile(3, 2, 4)
      @g.insert_tile(3, 3, 2)

      @g.moves_available?.must_equal(false)

    end

  end
end
