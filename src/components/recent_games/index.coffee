z = require 'zorium'
Q = require 'q'
log = require 'clay-loglevel'
_ = require 'lodash'

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

      z.request
        url: user.links.recentGames.href
        method: 'GET'
        background: true
    .then (games) ->
      _.map games, (game) ->
        new GameBox {game, iconSize: gameBoxSize},

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @gameBoxes
    .finally z.redraw
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
