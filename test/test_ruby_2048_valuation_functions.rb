#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

include Ruby2048::ValuationFunctions

describe "empty cell valuation" do
  it "should return the value of a board using empty cell valuation" do
    board = [
      [2, 2, nil, nil],
      [nil, nil, 2, 2],
      [2, 2, nil, nil],
      [2, 2, nil, nil]
    ]

    empty_cell_valuation(board).must_equal(8)
  end
end

describe "smoothness valuation" do
  it "should return the value of a board using smoothness criteria" do
    board = [
      [4, 2, 4, nil],
      [2, 32, nil, nil],
      [2, 16, 64, 128],
      [4, 16, nil, nil]
    ]

    smoothness_valuation(board).must_equal(662)

  end
end
