#!/usr/bin/env ruby
# encoding: UTF-8

require 'ruby_2048'
require 'securerandom'
require 'sinatra'

################################################################################
# Jason's API
#
# /create?encoding=json
# get => game_id
#
# /play/<game_id>
# json dict of game state (score, board, player name)
#
# /play/<game_id>?move=up/down/left/right
# json dict of game state (score, board, player name) after move applied
#
################################################################################

configure do
  set :games, {}
  set :encodings, {}
end

get '/' do
  redirect '/create'
end

get '/create/?' do

  opts = {}
  opts[:seed] = params['seed'] if params['seed']
  opts[:name] = params['player'] if params['player']

  id = SecureRandom.uuid.to_s
  settings.games[id] = Ruby2048::Game.new(opts)

  if params['encoding'] == 'json'
    settings.encodings[id] = :json
    id
  else
    settings.encodings[id] = :html
    redirect "/play/#{id}/"
  end

end

get '/play/:id/?' do |id|
  @id = id
  @game = settings.games[@id]

  if settings.encodings[id].nil? || settings.games[id].nil?
    "Game #{id} doesn't exist"
  else
    case settings.encodings[id]
    when :json
      settings.games[id].to_json
    else
      markaby :game
    end
  end
end

get '/play/:id/:direction/?' do |id, direction|
  @id = id
  @game = settings.games[@id]

  if settings.encodings[id].nil? || settings.games[id].nil?
    "Game #{id} doesn't exist"
  elsif !['up', 'down', 'left', 'right'].include?(direction)
    "You did not provide a valid direction: #{direction}"
  else
    @game.move(direction.to_sym)

    if settings.encodings[@id] == :json
      if @game.over?
        settings.games.delete(@id)
        settings.encodings.delete(@id)
      end
      return @game.to_json
    else
      if @game.over?
        redirect "/gameover/#{@id}"
      else
        redirect "/play/#{@id}"
      end
    end
  end

  settings.games[@id].to_json
end

get '/gameover/:id/?' do |id|
  @id = id

  if settings.encodings[id].nil? || settings.games[id].nil?
    "Game #{id} doesn't exist"
  else
    @game = settings.games[@id]

    settings.games.delete(@id)
    settings.encodings.delete(@id)

    markaby :gameover
  end
end

# This will calculate the move and return the new board without
# actually making the move.
# Will return json only
get '/test/:id/:direction/?' do |id, direction|
  @id = id
  @game = settings.games[@id]

  if settings.encodings[id].nil? || settings.games[id].nil?
    "Game #{id} doesn't exist"
  elsif !['up', 'down', 'left', 'right'].include?(direction)
    "You did not provide a valid direction: #{direction}"
  else
    test_game = @game.deep_copy
    test_game.move(direction.to_sym)
    test_game.to_json
  end
end

not_found do
  status 404
  'not found'
end
