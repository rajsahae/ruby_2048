#!/usr/bin/env ruby
# encoding: UTF-8

require 'minitest_helper'

describe Ruby2048 do
  it "has a version number" do
    refute_nil ::Ruby2048::VERSION
  end
end
