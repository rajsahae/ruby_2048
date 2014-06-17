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
      c.x.must_equal(0)
      c.y.must_equal(3)
    end

    it "has an array representation" do
      grid = [
        [2, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [2, nil, nil, nil]
      ]
        
      @g.insert_tile(2, 0, 3)
      @g.insert_tile(2, 0, 0)
      @g.to_a.must_equal(grid)
    end

    it "shifts tiles left" do
      @g.insert_tile(2, 3, 0)
      @g.insert_tile(2, 3, 3)

      @g.send(:shift_cells, :left)

      c1, c2 = @g.filled_cells

      c1.x.must_equal(0)
      c1.y.must_equal(0)
      c1.value.must_equal(2)

      c2.x.must_equal(0)
      c2.y.must_equal(3)
      c2.value.must_equal(2)
    end

    it "shifts staggered tiles left" do
      @g.insert_tile(4, 3, 0)
      @g.insert_tile(2, 1, 0)

      @g.send(:shift_cells, :left)

      c1, c2 = @g.filled_cells

      c1.x.must_equal(0)
      c1.y.must_equal(0)
      c1.value.must_equal(2)

      c2.x.must_equal(1)
      c2.y.must_equal(0)
      c2.value.must_equal(4)
    end

    it "shifts tiles right" do
      @g.insert_tile(2, 0, 1)
      @g.insert_tile(2, 2, 2)

      @g.send(:shift_cells, :right)

      c1, c2 = @g.filled_cells

      c1.x.must_equal(3)
      c1.y.must_equal(1)
      c1.value.must_equal(2)

      c2.x.must_equal(3)
      c2.y.must_equal(2)
      c2.value.must_equal(2)
    end

    it "shifts tiles up" do
      @g.insert_tile(2, 1, 3)
      @g.insert_tile(2, 2, 2)

      @g.send(:shift_cells, :up)

      c1, c2 = @g.filled_cells

      c1.x.must_equal(1)
      c1.y.must_equal(0)
      c1.value.must_equal(2)

      c2.x.must_equal(2)
      c2.y.must_equal(0)
      c2.value.must_equal(2)
    end

    it "shifts tiles down" do
      @g.insert_tile(2, 1, 1)
      @g.insert_tile(2, 3, 0)

      @g.send(:shift_cells, :up)

      c1, c2 = @g.filled_cells

      c1.x.must_equal(1)
      c1.y.must_equal(3)
      c1.value.must_equal(2)

      c2.x.must_equal(3)
      c2.y.must_equal(3)
      c2.value.must_equal(2)
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
