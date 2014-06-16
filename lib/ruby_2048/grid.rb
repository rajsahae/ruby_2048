#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/cell'

module Ruby2048
  class Grid
    def initialize(opts = {})
      opts = {
        :size => 4,
        :prng => Random.new
      }.merge(opts)

      @size = opts[:size]
      @prng = opts[:prng]

      # Cells are array of arrays with top left (0,0)
      @cells = Array.new(@size)
      @size.times do |y|
        @cells[y] = Array.new(@size)
        @size.times do |x|
          @cells[y][x] = Cell.new(x, y, nil)
        end
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
      @cells.flatten.select{ |c| c.available? }
    end

    public
    def insert_tile(num, x, y)
      @cells[y][x].value = num
    end

    public
    def filled_cells
      @cells.flatten.select{|c| !c.available? }
    end

    public
    def move_cells(direction)
      case direction
      when :up
      when :down
      when :left
      when :right
      else
        raise ArgumentError.new("Invalid direction provided: #{direction}")
      end
    end
  end
end

