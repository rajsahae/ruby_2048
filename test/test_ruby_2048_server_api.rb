#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

module Ruby2048
  describe ServerApi do

    before do
      @host = 'localhost'
      @port = 4567
      @s = ServerApi.new(@host, @port)
    end

    it "should take a host and optional port" do
      @s.host.must_equal(@host)
      @s.port.must_equal(@port)
    end

    it "should have a create method" do
      @s.must_respond_to(:create)
    end

    it "generates a correct create url" do
      @s.create_uri.to_s.must_equal("http://#{@host}:#{@port}/create")
    end

    specify "create takes optional name, encoding, and seed" do
      name = 'testname'
      encoding = 'json'
      seed = 5

      uri = "http://#{@host}:#{@port}/create?name=testname&encoding=json&seed=5"

      @s.create_uri(name, encoding, seed).to_s.must_equal(uri)
    end

    it "generates a correct play uri" do
      id = 123456
      @s.play_uri(id).to_s.must_equal("http://#{@host}:#{@port}/play/#{id}")
    end

    it "generates a correct play uri with a move" do
      id = 123456
      move = 'up'
      @s.play_uri(id, move).to_s.must_equal("http://#{@host}:#{@port}/play/#{id}/#{move}")
    end

  end # describe ServerApi
end # module Ruby2048
