# Game was loaded in picker
if kik?.picker?.reply
  kik.picker.reply()
  throw new Error('ignore')

_ = require 'lodash'
z = require 'zorium'
log = require 'loglevel'
config = require './config'
log.enableAll()

GamesPage = require './pages/games'
PlayGamePage = require './pages/play_game'

route = (routes) ->
  _.transform routes, (result, Component, route) ->
    result[route] =
      controller: => @component = new Component(z.route.param)
      view: => @component.render()

# Kik changes app if the url changes, so don't change it
z.route.mode = 'hash'
z.route document.getElementById('app'), '/', route(
  '/': GamesPage
  '/game/:key': PlayGamePage
  '/games/:filter': GamesPage
)

# If this was loaded as a game page (abc.clay.io), pciker marketplace for hit
host = window.location.host
targetHost = config.APP_HOST
unless host == targetHost
  host = host.split '.'
  gameKey = host[0]
  z.route "/game/#{gameKey}"
  kik.picker('http://192.168.2.98.xip.io:3000', {}, -> null)

log.info 'App Ready'
