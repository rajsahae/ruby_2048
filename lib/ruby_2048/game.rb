#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/grid'

module Ruby2048
  class Game
    def initialize(opts = {})
      opts = {
        :tiles => 2,
        :seed => Random.new_seed
      }.merge(opts)

      @start_tiles = opts[:tiles]
      @seed = opts[:seed]
      @prng = Random.new(@seed)
      @grid = Grid.new(:prng => @prng)

      add_start_tiles
    end
    attr_reader :start_tiles, :seed, :grid

    public
    def next_tile
      @prng.rand(1.0) < 0.9 ? 2 : 4
    end

    public
    def move(direction)
      return nil if over?
      @grid.shift_cells(direction)
      @grid.combine_cells(direction)
      insert_random_tile
      @grid.to_a
    end

    public
    def over?
      !@grid.moves_available?
    end

    private
    def add_start_tiles
      @start_tiles.times do
        insert_random_tile
      end
    end

    private
    def insert_random_tile
      cell = @grid.random_cell
      @grid.insert_tile(cell.row, cell.col, next_tile)
    end

  end
end
