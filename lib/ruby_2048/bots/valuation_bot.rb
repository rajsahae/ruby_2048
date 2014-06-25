#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/bots/valuation_functions'
require 'ruby_2048/server_api'
require 'json'

include Ruby2048::ValuationFunctions

def best_move(game)
  current_score = game['score']
  current_board = game['game']
  values = []
  boards = []
  moves = %w(up down left right)

  # go through each move, save value of resulting board
  moves.each do |move|
    json = @api.test(@id, move)
    test_game = JSON.parse(json)
    boards.push(test_game['game'])

    score_value = test_game['score'] - current_score
    empty_cell_value = empty_cell_valuation(test_game['game'])
    smoothness_value = smoothness_valuation(test_game['game'])
    monotonicity_value = monotonicity_valuation(test_game['game'])

    values.push(5*score_value + 1*empty_cell_value - 2*smoothness_value - 2*monotonicity_value)
  end

  # If any boards are exactly the same as the current board, set their
  # value to -INFINITY
  boards.each_with_index do |board, index|

    if board == current_board
      values[index] = -Float::INFINITY
    end
  end

  # If all values are the same, pick a random one, otherwise return the max
  if values.uniq.size == 1
    return moves[rand(3)]
  else
    return moves[values.index(values.max)]
  end
end

def dup_hash(ary)
  ary.inject(Hash.new(0)) { |h,e| h[e] += 1; h }.select { 
    |k,v| v > 1 }.inject({}) { |r, e| r[e.first] = e.last; r }
end

def dup_hash2(ary)
  hsh = Hash.new(0)
  ary.each{|v| hsh.store(v, hsh[v].next) }
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

  seed = ARGV[1].nil? ? nil : ARGV[1].to_i

  @api = Ruby2048::ServerApi.new(host, port)

  @id = @api.create('valuation bot', 'json', seed)

  index = 0
  hash = {}
  json = @api.play(@id)

  moves = []

  loop do
    hash = JSON.parse(json)
    break if hash['gameover'] == true

    move = best_move(hash)
    moves.push(move)
    json = @api.play(@id, move)
    index += 1
  end

  puts "Total num moves: #{index}"
  puts "Move breakdown: #{dup_hash(moves)}"
  puts "Final score: #{hash['score']}"
  puts "Final board:"
  hash['game'].each { |row| p row }
end

if __FILE__ == $0
  main
end
