#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/server_api'
require 'json'

def best_greedy_move(board)
  max = [nil, nil, 0]
  board.size.times do |y|
    board[y].size.times do |x|
      next if board[y][x].nil?

      unless y == 0 
        if board[y][x] == board[y-1][x] 
          max = [[y,x],[y-1,x],board[y][x]*2] unless max[2] > board[y][x]*2
        end
      end

      unless y == board.size - 1 
        if board[y][x] == board[y+1][x] 
          max = [[y,x],[y+1,x],board[y][x]*2] unless max[2] > board[y][x]*2
        end
      end

      unless x == 0
        if board[y][x] == board[y][x-1] 
          max = [[y,x],[y,x-1],board[y][x]*2] unless max[2] > board[y][x]*2
        end
      end

      unless x == board.size - 1
        if board[y][x] == board[y][x+1] 
          max = [[y,x],[y,x+1],board[y][x]*2] unless max[2] > board[y][x]*2
        end
      end

    end
  end

  if max[0].nil?
    return %w(up down left right)[rand(4)]
  elsif max[0][0] == max[1][0]
    # on the same row, move left or right
    return %w(left right)[rand(2)]
  elsif max[0][1] == max[1][1]
    return %w(up down)[rand(2)]
  else
    abort "greedy move error: #{max}"
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

  id = @api.create('lurd bot', 'json', 5)

  index = 0
  hash = {}
  json = @api.play(id)


  loop do
    hash = JSON.parse(json)
    board = hash['game']
    move = best_greedy_move(board)

    json = @api.play(id, move)
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
