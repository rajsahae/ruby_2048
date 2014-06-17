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
      @cells.map do |row|
        row.map do |cell|
          cell.value
        end
      end
    end

    public
    def shift_cells(direction)
      case direction
      when :up
      when :down
      when :left
        @size.times do |i|
          next if @cells[i].all?{|c| c.available? }
          next if @cells[i].all?{|c| !c.available? }

        end
      when :right
        @cells.each do |row|
          next if row.all?{|c| c.available?}
          while row.last.available?
            row.unshift(row.pop)
          end
        end
      else
        raise ArgumentError.new("Invalid direction provided: #{direction}")
      end

      renumber_cells
    end

    private
    def renumber_cells
      @size.times do |y|
        @size.times do |x|
          @cells[y][x].x = x
          @cells[y][x].y = y
        end
      end
    end
  end
end

