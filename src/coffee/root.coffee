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

window.addEventListener 'fb-flo-reload', z.redraw

route = (routes) ->
  _.transform routes, (result, Component, route) ->
    result[route] =
      controller: => @component = new Component(z.route.param)
      view: => @component.render()

# TODO: (Zoli) route from pathname to hash for kik
# Kik changes app if the url changes, so don't change it
# Also, if someone recieved a link with a hash, respect it
if kik?.enabled or not window.history?.pushState or window.location.hash
  z.route.mode = 'hash'
else
  z.route.mode = 'pathname'

z.route document.getElementById('app'), '/', route(
  '/': GamesPage
  '/game/:key': PlayGamePage
  '/games/:filter': GamesPage
)

# push tokens let us communicate with kik users after they've left app
kik?.ready ->
  kik.push.getToken (token) ->
    return if not token
    PushToken = require './models/push_token'
    PushToken.all('pushTokens').create
      token: token
      source: 'kik'

# If this was loaded as a game page (abc.clay.io), picker marketplace for hit
hostname = window.location.hostname
targetHost = config.HOSTNAME

unless hostname is targetHost or config.MOCK
  host = hostname.split '.'
  gameKey = host[0]
  z.route "/game/#{gameKey}"
  kik.picker?("http://#{targetHost}", {}, -> null)

log.info 'App Ready'

# TODO: (Austin) Feature-detection for SVG
# we'll want to move this somewhere cleaner
svgSupport = !! document.createElementNS?('http://www.w3.org/2000/svg', 'svg')
                .createSVGRect
unless svgSupport
  document.body.className += ' no-svg'
