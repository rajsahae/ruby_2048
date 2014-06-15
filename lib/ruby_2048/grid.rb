#!/usr/bin/env ruby
# encoding: UTF-8

module Ruby2048
  class Grid
    def initialize(opts = {})
      opts = {
        :size => 4,
        :prng => Random.new
      }.merge(opts)

      @size = opts[:size]
      @prng = opts[:prng]
    end
    attr_reader :size, :prng

  end
end

