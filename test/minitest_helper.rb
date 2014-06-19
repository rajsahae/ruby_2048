$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
ENV['RACK_ENV'] = 'test'

require 'ruby_2048'
require 'ruby_2048/server'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
