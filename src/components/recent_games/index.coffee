z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../../lib/request'
Game = require '../../models/game'
User = require '../../models/user'
GameBox = require '../game_box'

styles = require './index.styl'

module.exports = class RecentGames
  constructor: ->
    styles.use()

    if window.matchMedia('(min-width: 360px)').matches
      gameBoxSize = 100
    else
      gameBoxSize = 135

    @gameBoxes = z.prop User.getMe().then (user) ->
      unless user.links.recentGames
        return []

      request user.links.recentGames.href
    .then (games) ->
      _.map games, (game) ->
        new GameBox {game, iconSize: gameBoxSize},

    Promise.resolve @gameBoxes
    .then z.redraw
    .catch log.trace

  render: =>
    if _.isEmpty @gameBoxes()
      return

    z 'section.recent-games',
      z 'div.l-content-container',
        z 'h2.recent-games-header', 'Continue playing'
        z 'div.recent-games-game-boxes',
          _.map @gameBoxes(), (GameBox) ->
            z 'div.recent-games-game-box-container',
              GameBox.render()
