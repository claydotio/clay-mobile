z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

GameFilter = require '../../models/game_filter'
GameBox = require '../game_box'
GamePromo = require '../game_promo/with_info'
Spinner = require '../spinner'

styles = require './popular_small_top.styl'

LOAD_MORE_GAMES_LIMIT = 13
SCROLL_THRESHOLD = 250

elTopPosition = ($el) ->
  if $el
  then $el.offsetTop + elTopPosition($el.offsetParent)
  else 0

module.exports = class GameResults
  constructor: ->
    styles.use()

    @gameLinks = []

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
    @isListeningForScroll = true

  onMount: ($el) =>
    @$el = $el

    # Bind event listeners
    window.addEventListener 'scroll', @scrollListener
    window.addEventListener 'resize', @scrollListener

    @scrollListener()

  onBeforeUnmount: =>
    window.removeEventListener 'scroll', @scrollListener
    window.removeEventListener 'resize', @scrollListener

  scrollListener: =>
    unless @isListeningForScroll
      return

    # Infinite Scroll
    $el = @$el

    scrollTop = window.pageYOffset
    scrollTop ?= document.documentElement.scrollTop
    scrollTop ?= document.body.parentNode.scrollTop
    scrollTop ?= document.body.scrollTop

    totalScrolled = elTopPosition($el) + $el.offsetHeight
    totalScrollHeight = scrollTop + window.innerHeight

    if totalScrolled - totalScrollHeight < SCROLL_THRESHOLD
      @isListeningForScroll = false

      return @loadMore().then (shouldStop) =>
        unless shouldStop
          @isListeningForScroll = true
          return @scrollListener()
      .catch log.trace

  loadMore: =>
    @isLoading = true
    z.redraw()

    GameFilter.getGames
      limit: LOAD_MORE_GAMES_LIMIT
      skip: @gameLinks.length
    .then (games) =>
      @gameLinks = @gameLinks.concat _.map games, (game, index) =>
        if index is 0
          type: 'featured'
          module: new GamePromo(
            {game, width: @gamePromoWidth, height: @gamePromoHeight}
          )
        else
          type: 'default', module: new GameBox {game, iconSize: @gameBoxSize}

      @isLoading = false

      # TODO: (Zoli) force redraw once Zorium batches draws
      z.redraw()

      # Stop loading more
      if _.isEmpty games
        return true

  render: =>
    z 'section.game-results',
      z 'div.l-content-container',
        z 'h2.game-results-header', 'Most popular games'
          z 'div.game-results-game-boxes',
          (_.map @gameLinks, (gameLink) ->
            if gameLink.type is 'featured'
              z '.game-results-featured-game-box-container',
                gameLink.module
            else
              z '.game-results-game-box-container',
                gameLink.module
          ).concat [
            if @isLoading then z '.game-results-spinner', @Spinner
          ]
