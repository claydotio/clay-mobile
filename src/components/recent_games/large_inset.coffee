z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../../lib/request'
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

    @gamePromos = []
    User.getMe().then (user) ->
      unless user.links.recentGames
        return []
      request user.links.recentGames.href
    .then (games) =>
      @gamePromos = _.map games, (game) ->
        new GamePromo {game, width: gamePromoWidth, height: gamePromoHeight}
    .then z.redraw
    .catch log.trace

  render: =>
    if _.isEmpty @gamePromos()
      return

    z 'section.recent-games',
      z 'div.l-content-container',
        z 'div.recent-games-game-boxes',
          _.map @gamePromos, (GamePromo) ->
            z 'div.recent-games-game-box-container',
              GamePromo
