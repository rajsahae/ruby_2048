#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048/server_api'
require 'json'
require 'curses'
include Curses


def show_board(board)
  # ---------------------
  # |2048|   0|   0|   0|
  # ---------------------
  # |2048|   0|   0|   0|
  # ---------------------
  # |2048|   0|   0|   0|
  # ---------------------
  # |2048|   0|   0|   0|
  # ---------------------

  width = 27
  height = 9 
  win = Window.new(height, width, (lines - height) / 2, (cols - width) / 2)
  win.box(?|, ?-) 

  board.size.times do |r| 
    win.setpos(r*2+1,1)
    format = []
    board[r].each{|n| format << (n.nil? ? "%4s" : "%4d") }
    format = format.join(' | ')
    win.addstr(sprintf(format, *board[r].map{|n| n.nil? ? ' ' : n })) 
    win.setpos(r*2+2,1)
    win.addstr('-'*25)
    win.refresh
  end 
end

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

gamelog = []
@api = Ruby2048::ServerApi.new(host, port)

id = @api.create('game recorder', 'json', 5)

index = 0
hash = {}
json = @api.play(id)

init_screen
begin

  crmode

  File.open("game_log_#{id}.log", 'w') do |log|
    loop do
      hash = JSON.parse(json)
      show_board(hash['game'])
      refresh
      break if hash['gameover'] == true

      move = ''
      case getch
      when 'B'
        move = 'down'
      when 'A'
        move = 'up'
      when 'D'
        move = 'left'
      when 'C'
        move = 'right'
      end

      log.puts("#{hash} : #{move}")

      json = @api.play(id, move)
      index += 1
    end

    puts "Total num movess: #{index}"
    puts "Final score: #{hash['score']}"
    puts "Final board:"
    hash['game'].each { |row| p row }
    log.puts("#{hash} : #{move}")
  end
ensure
  close_screen
end
