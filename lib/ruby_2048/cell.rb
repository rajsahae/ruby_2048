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

    def <=> other_cell
      if self.value.nil? && other_cell.value.nil?
        0
      elsif self.value.nil?
        -1
      elsif other_cell.value.nil?
        1
      else
        self.value <=> other_cell.value
      end
    end

    def === other_cell
      self.value == other_cell.value
    end
  end
end
