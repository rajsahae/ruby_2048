#!/usr/bin/env ruby
# encoding: UTF-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_2048/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_2048'
  spec.version       = Ruby2048::VERSION
  spec.authors       = ['Raj Sahae']
  spec.email         = ['rsahae@teslamotors.com']
  spec.summary       = %q{ Basic ruby implementation of the game 2048.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'shotgun'
  spec.add_development_dependency 'rack-test'
  spec.add_dependency 'sinatra'
  spec.add_dependency 'markaby'
  spec.add_dependency 'curses'
end

