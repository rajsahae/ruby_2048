#!/usr/bin/env ruby
# encoding: UTF-8

require 'uri'
require 'net/http'

module Ruby2048
  class ServerApi
    def initialize(host, port)
      @host, @port = host, port
    end
    attr_reader :host, :port

    public
    def create(name = nil, encoding = nil, seed = nil)
      server_get(create_uri(name, encoding, seed))
    end

    public
    def play(id, move = nil)
      server_get(play_uri(id, move))
    end

    public
    def create_uri(name = nil, encoding = nil, seed = nil)
      query = []
      query << "name=#{name}"         unless name.nil?
      query << "encoding=#{encoding}" unless encoding.nil?
      query << "seed=#{seed}"         unless seed.nil?
      
      build_hash = {
        :host => @host,
        :port => @port,
        :path => '/create',
      }

      build_hash[:query] = URI.encode(query.join('&')) unless query.empty?

      URI::HTTP.build(build_hash)
    end

    public
    def play_uri(id, move = nil)
      path = ['play', id]
      path << move unless move.nil?

      build_hash = {
        :host => @host,
        :port => @port,
        :path => '/' + path.join('/')
      }

      URI::HTTP.build(build_hash)
    end

    public
    def test(id, move)
      server_get(test_uri(id, move))
    end

    public
    def test_uri(id, move)
      path = ['test', id, move]

      build_hash = {
        :host => @host,
        :port => @port,
        :path => '/' + path.join('/')
      }

      URI::HTTP.build(build_hash)
    end

    private
    def server_get(uri)
      Net::HTTP.get(uri)
    end
  end
end

