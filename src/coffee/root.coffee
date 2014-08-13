_ = require 'lodash'
z = require 'zorium'
log = require 'loglevel'

GamesPage = require './pages/games'
log.enableAll()

route = (routes) ->
  _.transform routes, (result, Component, route) ->
    result[route] =
      controller: => @component = new Component(z.route.param)
      view: => @component.render()

z.route.mode = if window.history?.pushState then 'pathname' else 'hash'
z.route document.getElementById('app'), '/', route(
  '/': GamesPage
  '/games/:filter': GamesPage
)

log.info 'App Ready'
