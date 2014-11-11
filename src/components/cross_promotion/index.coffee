z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
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

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @gameBoxes
    .finally z.redraw
    .catch log.trace

  render: =>
    z 'div.cross-promotion',
      _.map @gameBoxes(), (GameBox) ->
        z 'div.cross-promotion-game-box',
          GameBox.render()
