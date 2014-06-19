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
    redirect "/play/#{@id}"
  end
end

not_found do
  status 404
  'not found'
end