z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
GameBox = require '../game_box'

styles = require './index.styl'

module.exports = class CrossPromotion
  constructor: ->
    styles.use()

    randomVariance = Math.floor(Math.random() * 4)
    @state = z.state
      games: z.observe (Game.getTop(limit: 2, skip: randomVariance)
      ).catch log.trace
      $gameBox: new GameBox()

  render: ({iconSize}) =>
    {games, $gameBox} = @state()

    z 'div.z-cross-promotion',
      _.map games, (game) ->
        z 'div.game-box',
          z $gameBox, {game, iconSize}
