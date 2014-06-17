#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

module Ruby2048

  describe Cell do

    before do
      @cell = Cell.new(0, 0, 2)
    end

    it "should have an x coordinate" do
      @cell.x.must_equal(0)
    end

    it "should have a y coordinate" do
      @cell.y.must_equal(0)
    end

    it "should have a value" do
      @cell.value.must_equal(2)
    end

    it "should use the comparison operator by value" do
      other = Cell.new(1, 1, 4)
      nil_cell = Cell.new(2, 2, nil)

      @cell.<=>(other).must_equal(-1)
      other.<=>(@cell).must_equal(1)
      @cell.<=>(@cell).must_equal(0)

      (@cell <=> nil_cell).must_equal(1)
      (nil_cell <=> @cell).must_equal(-1)
    end

    it "should use the === operator by value" do
      other = Cell.new(1, 1, 4)

      (@cell === other).wont_equal(true)
      (@cell === @cell).must_equal(true)
    end
  end
end
