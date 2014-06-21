#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'
require 'rack/test'

module Ruby2048

  describe "Server" do
    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    it "should return the id for json encoded games" do
      rfc4122 = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
      get '/create?encoding=json'
      last_response.ok?.must_equal(true)
      last_response.body.must_match(rfc4122)
    end

    # it "should redirect to /play/id for regular games" do
    #   get '/create'
    #   p last_response
    #   last_response.ok?.must_equal(true)
    # end
  end

end
