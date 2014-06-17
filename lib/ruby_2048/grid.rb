#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/cell'
require 'matrix'

module Ruby2048
  class Grid
    def initialize(opts = {})
      opts = {
        :size => 4,
        :prng => Random.new
      }.merge(opts)

      @size = opts[:size]
      @prng = opts[:prng]

      # Cells are ruby matrix, row/column
      @cells = Matrix.build(@size) do |row, col|
        Cell.new(row, col, nil)
      end
    end
    attr_reader :size, :prng, :cells

    public
    def random_cell
      ac = available_cells
      ac[@prng.rand(ac.size)]
    end

    public
    def available_cells
      @cells.to_a.flatten.select{ |c| c.available? }
    end

    public
    def insert_tile(num, row, col)
      @cells[row, col].value = num
    end

    public
    def filled_cells
      @cells.to_a.flatten.select{|c| !c.available? }
    end

    public
    def combine_cells(direction)

      case direction
      when :up
      when :down
      when :left
      when :right
      else
        raise ArgumentError.new("Invalid direction provided: #{direction}")
      end
    end

    public
    def to_a
      @cells.to_a.map do |row|
        row.map do |n|
          n.value
        end
      end
    end

    public
    def shift_cells(direction)
      cells = @cells.to_a

      case direction
      when :up, :down
        rotate_cells(:right)
        if direction == :up
          shift_cells(:right)
        elsif direction == :down
          shift_cells(:left)
        end
        rotate_cells(:left)
      when :left, :right
        cells = Grid.compact_cells(cells)
        cells.map! do |row|
          while row.size < @size
            if direction == :left
              row.push(Cell.new(nil, nil, nil))
            elsif direction == :right
              row.unshift(Cell.new(nil, nil, nil))
            end
          end
          row
        end
      else
        raise ArgumentError.new("Invalid direction provided: #{direction}")
      end

      @cells = Grid.renumber_cells(cells)
    end

    public
    def rotate_cells(direction)
      @cells =  if direction == :right
                  Matrix[*@cells.transpose.to_a.map(&:reverse)]
                elsif direction == :left
                  Matrix[*@cells.to_a.map(&:reverse)].transpose
                end
    end

    public
    def self.renumber_cells(cells)
      cells.size.times do |row|
        cells.size.times do |col|
          cells[row][col].row = row
          cells[row][col].col = col
        end
      end
      return cells
    end

    public
    def self.compact_cells(cells)
      cells.map do |row|
        next row if row.all?{|c| c.available? } || row.all?{|c| !c.available? }
        row.inject([]){|m, c| m.push(c) unless c.value.nil?; m }
      end
    end

  end
end

