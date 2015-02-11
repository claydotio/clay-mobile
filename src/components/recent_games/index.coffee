z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../../lib/request'
Game = require '../../models/game'
User = require '../../models/user'
GameShoeBox = require '../game_shoe_box'

styles = require './index.styl'

module.exports = class RecentGames
  constructor: ->
    styles.use()

    @gameShoeBoxes = []
    User.getMe().then (user) ->
      unless user.links.recentGames
        return []

      request user.links.recentGames.href
    .then (games) =>
      @gameShoeBoxes = _.map games.slice(0, 3), (game) ->
        new GameShoeBox {game},
    .then z.redraw
    .catch log.trace

  render: =>
    if _.isEmpty @gameShoeBoxes
      return

    z 'section.z-recent-games',
      z 'h2.header', 'Recently Played'
      z 'div.game-boxes',
        _.map @gameShoeBoxes, (gameShoeBox) ->
          z 'div.game-box-container',
            gameShoeBox
