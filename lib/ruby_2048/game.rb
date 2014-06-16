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
      @grid.move_cells(direction)
    end

    private
    def add_start_tiles
      @start_tiles.times do
        cell = @grid.random_cell
        @grid.insert_tile(next_tile, cell.x, cell.y)
      end
    end

  end
end
