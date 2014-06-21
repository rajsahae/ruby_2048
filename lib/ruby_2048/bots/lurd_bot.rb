#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/server_api'
require 'json'

case ARGV[0]
when 'heroku'
  host='ruby-2048.herokuapp.com'
  port=80
when 'local'
  host='localhost'
  port=4567
else
  abort "specify heroku or local"
end

@api = Ruby2048::ServerApi.new(host, port)

id = @api.create('lurd bot', 'json', 5)

index = 0
moves = %w(left up right down)
hash = {}


loop do
  json = @api.play(id, moves[index%4])
  hash = JSON.parse(json)
  p hash
  break if hash['gameover'] == true
  index += 1
end
