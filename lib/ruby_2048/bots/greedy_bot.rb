#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/server_api'
require 'json'

def best_greedy_move(game)
  current_score = game['score']
  scores = []
  moves = %w(up down left right)
  moves.each do |move|
    scores.push(@api.test(@id, move)['score'])
  end
  if scores.uniq.size == 1
    return moves[rand(3)]
  else
    return moves[scores.index(scores.max)]
  end
end

def main
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

  @id = @api.create('greedy bot', 'json', 5)

  index = 0
  hash = {}
  json = @api.play(@id)


  loop do
    hash = JSON.parse(json)
    board = hash['game']
    move = best_greedy_move(hash)

    json = @api.play(@id, move)
    break if hash['gameover'] == true
    index += 1
  end

  puts "Total num movess: #{index}"
  puts "Final score: #{hash['score']}"
  puts "Final board:"
  hash['game'].each { |row| p row }
end

if __FILE__ == $0
  main
end
