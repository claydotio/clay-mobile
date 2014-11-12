z = require 'zorium'
Q = require 'q'
log = require 'clay-loglevel'
_ = require 'lodash'

Game = require '../../models/game'
User = require '../../models/user'
GamePromo = require '../game_promo/with_info_inset'

styles = require './large_inset.styl'

module.exports = class RecentGames
  constructor: ->
    styles.use()

    if window.matchMedia('(min-width: 360px)').matches
      gamePromoWidth = 320
      gamePromoHeight = 204
    else
      gamePromoWidth = 280
      gamePromoHeight = 178

    @gamePromos = z.prop User.getMe().then (user) ->
      unless user.links.recentGames
        return []
      z.request
        url: user.links.recentGames.href
        method: 'GET'
        background: true
    .then (games) ->
      _.map games, (game) ->
        new GamePromo {game, width: gamePromoWidth, height: gamePromoHeight}

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @gamePromos
    .finally z.redraw
    .catch log.trace

  render: =>
    if _.isEmpty @gamePromos()
      return

    z 'section.recent-games',
      z 'div.l-content-container',
        z 'div.recent-games-game-boxes',
          _.map @gamePromos(), (GamePromo) ->
            z 'div.recent-games-game-box-container',
              GamePromo.render()
