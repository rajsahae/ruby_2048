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
    # Row, column, number/value
    def insert_tile(row, col, num)
      raise ArgumentError.new("Row out of bounds: #{row}") if row >= @size || row < 0
      raise ArgumentError.new("Col out of bounds: #{col}") if col >= @size || col < 0
      
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
        @cells.column_size.times do |col|
          index = 0
          while index.next < @size
            current_cell = @cells[index, col]
            next_cell = @cells[index.next, col]

            if !current_cell.value.nil? && current_cell === next_cell
              current_cell.value = current_cell.value*2
              next_cell.value = nil
              index += 2
            else
              index += 1
            end
          end
          shift_cells(:up)
        end
      when :down
        @cells.column_size.times do |col|
          index = @size - 1
          while index > 0
            current_cell = @cells[index, col]
            next_cell = @cells[index - 1, col]

            if !current_cell.value.nil? && current_cell === next_cell
              current_cell.value = current_cell.value*2
              next_cell.value = nil
              index -= 2
            else
              index -= 1
            end
          end
          shift_cells(:down)
        end
      when :left
        @cells.row_size.times do |row|
          index = 0
          while index.next < @size
            current_cell = @cells[row, index]
            next_cell = @cells[row, index + 1]

            if !current_cell.value.nil? && current_cell === next_cell
              current_cell.value = current_cell.value*2
              next_cell.value = nil
              index += 2
            else
              index += 1
            end
          end
          shift_cells(:left)
        end
      when :right
        @cells.row_size.times do |row|
          index = @size - 1
          while index > 0
            current_cell = @cells[row, index]
            next_cell = @cells[row, index - 1]

            if !current_cell.value.nil? && current_cell === next_cell
              current_cell.value = current_cell.value*2
              next_cell.value = nil
              index -= 2
            else
              index -= 1
            end
          end
          shift_cells(:right)
        end
      else
        raise ArgumentError.new("Invalid direction provided: #{direction}")
      end
    end

    public
    def to_a
      @cells.collect{|n| n.value }.to_a
    end

    public
    def shift_cells(direction, renum = true)
      require 'pp'

      case direction
      when :up, :down

        rotate_cells(:right)

        if direction == :up
          shift_cells(:right, false)
        elsif direction == :down
          shift_cells(:left, false)
        end

        rotate_cells(:left)

      when :left, :right

        @cells = Grid.compact_cells(@cells.to_a)

        @cells.map! do |row|
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

      @cells = Matrix[*@cells] if @cells.is_a? Array
      renumber_cells if renum

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
    def renumber_cells
      @cells.each_with_index do |e, row, col| 
        e.row = row
        e.col = col
      end
      return @cells
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

