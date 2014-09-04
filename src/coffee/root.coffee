# Game was loaded in picker
if kik?.picker?.reply
  kik.picker.reply()
  throw new Error('ignore')

_ = require 'lodash'
z = require 'zorium'
log = require 'loglevel'

config = require './config'

reportError = ->

  # Remove the circular dependency within error objects
  args = _.map arguments, (arg) ->
    if arg instanceof Error
    then arg.stack
    else if arg instanceof ErrorEvent
    then arg.error.stack
    else arg

  z.request
    method: 'POST'
    url: config.API_PATH + '/log'
    data: {message: JSON.stringify(args)}

window.addEventListener 'error', reportError
window.addEventListener 'fb-flo-reload', z.redraw

log.on 'error', reportError

if config.ENV != config.ENVS.PROD
  log.enableAll()
else
  log.setLevel 'error'

GamesPage = require './pages/games'
PlayGamePage = require './pages/play_game'
PushToken = require './models/push_token'

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
# TODO: (Austin) remove localStorage in favor of anonymous user sessions
if not localStorage['pushTokenStored']
  kik?.ready? ->
    kik.push.getToken (token) ->
      return if not token
      PushToken.all('pushTokens').post
        token: token
        source: 'kik'
      .then ->
        localStorage['pushTokenStored'] = 1
      .catch log.error

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
