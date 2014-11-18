z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../../lib/request'
Game = require '../../models/game'
User = require '../../models/user'
GameShoeBox = require '../game_shoe_box'

styles = require './list.styl'

module.exports = class RecentGames
  constructor: ->
    styles.use()

    @gameShoeBoxes = []
    User.getMe().then (user) ->
      unless user.links.recentGames
        return []

      request user.links.recentGames.href
    .then (games) =>
      @gameShoeBoxes = _.map games, (game) ->
        new GameShoeBox {game},
    .then z.redraw
    .catch log.trace

  render: =>
    if _.isEmpty @gameShoeBoxes
      return

    z 'section.recent-games',
      z 'div.l-content-container',
        z 'h2.recent-games-header', 'Recently Played'
        z 'div.recent-games-game-boxes',
          _.map @gameShoeBoxes, (gameShoeBox) ->
            z 'div.recent-games-game-box-container',
              gameShoeBox
