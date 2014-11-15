z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
GameBox = require '../game_box'

styles = require './index.styl'

module.exports = class CrossPromotion
  constructor: ({iconSize}) ->
    styles.use()

    randomVariance = Math.floor(Math.random() * 4)
    @gameBoxes = z.prop Game.getTop(limit: 2, skip: randomVariance)
    .then (games) ->
      _.map games, (game) ->
        new GameBox {game, iconSize},

    Promise.resolve @gameBoxes
    .then z.redraw
    .catch log.trace

  render: =>
    z 'div.cross-promotion',
      _.map @gameBoxes(), (GameBox) ->
        z 'div.cross-promotion-game-box',
          GameBox.render()
