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

      @num_start_tiles = opts[:tiles]
      @seed = opts[:seed]
      @prng = Random.new(@seed)
      @grid = Grid.new(:prng => @prng)
    end
    attr_reader :num_start_tiles, :seed, :grid

    def next_tile
      @prng.rand(1.0) < 0.9 ? 2 : 4
    end

  end
end
