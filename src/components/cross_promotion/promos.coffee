z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'clay-loglevel'

Game = require '../../models/game'
GamePromo = require '../game_promo'

require './promos.styl'

module.exports = class CrossPromotionPromos
  constructor: ({gamePromoWidth, gamePromoHeight}) ->
    @gamePromos = z.prop Game.getTop(limit: 6).then (games) ->
      _.map games, (game) ->
        new GamePromo {game, width: gamePromoWidth, height: gamePromoHeight}

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @gamePromos
    .finally z.redraw
    .catch log.trace

  render: =>
    z 'div.cross-promotion-promos',
      _.map @gamePromos(), (GamePromo) ->
        z 'div.cross-promotion-promos-game-promo',
          GamePromo.render()
