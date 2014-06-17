#!/usr/bin/env ruby
# encoding: UTF-8

module Ruby2048
  Cell = Struct.new(:row, :col, :value) do
    def available?
      value.nil?
    end

    def == other_cell
      self.row == other_cell.row && self.col == other_cell.col
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
