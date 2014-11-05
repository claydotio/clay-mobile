z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'clay-loglevel'

GameFilter = require '../../models/game_filter'
GameBox = require '../game_box'
GamePromo = require '../game_promo/with_info'
InfiniteScrollDir = require '../../directives/infinite_scroll'
Spinner = require '../spinner'

styles = require './popular_small_top.styl'

LOAD_MORE_GAMES_LIMIT = 13

module.exports = class GameResults
  constructor: ->
    styles.use()

    @infiniteScrollDir = new InfiniteScrollDir loadMore: @loadMore
    @gameLinks = z.prop []

    if window.matchMedia('(min-width: 360px)').matches
      @gameBoxSize = 100
      @gamePromoWidth = 320
      @gamePromoHeight = 204
    else
      @gameBoxSize = 135
      @gamePromoWidth = 280
      @gamePromoHeight = 178

    @Spinner = new Spinner()
    @isLoading = true

  loadMore: =>
    GameFilter.getGames
      limit: LOAD_MORE_GAMES_LIMIT
      skip: @gameLinks().length
    .then (games) =>
      @gameLinks @gameLinks().concat _.map games, (game, index) =>
        if index is 0
          type: 'featured'
          module: new GamePromo(
            {game, width: @gamePromoWidth, height: @gamePromoHeight}
          )
        else
          type: 'default', module: new GameBox {game, iconSize: @gameBoxSize}

      @isLoading = false

      # force
      z.redraw(true)

      # Stop loading more
      if _.isEmpty games
        return true

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
      z 'div.l-content-container',
        z 'h2.game-results-header', 'Most popular games'
          z 'div.game-results-game-boxes',
          (_.map @gameLinks(), (gameLink) ->
            if gameLink.type is 'featured'
              z '.game-results-featured-game-box-container',
                gameLink.module.render()
            else
              z '.game-results-game-box-container',
                gameLink.module.render()
          ).concat [
            if @isLoading then z '.game-results-spinner', @Spinner.render()
          ]
