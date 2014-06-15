#!/usr/bin/env ruby
# encoding: UTF-8

module Ruby2048
  Cell = Struct.new(:x, :y, :value) do
    def available?
      value.nil?
    end

    def == other_cell
      other_cell.x == x && other_cell.y == y
    end
  end
end
