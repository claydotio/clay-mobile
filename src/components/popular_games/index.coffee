z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
GameBox = require '../game_box'
GamePromo = require '../game_promo'
Spinner = require '../spinner'
GooglePlayAdModalControl = require '../google_play_ad_modal'
GooglePlayAdModalHeaderBackground =
  require '../google_play_ad_modal/header_background'

styles = require './index.styl'

# loading 13 at a time lets the featured images load in the right position for
# each batch. 12 (least common multiple of 2, 3) normal images + 1 featured
LOAD_MORE_GAMES_LIMIT = 13
SCROLL_THRESHOLD = 250
BOXES_PER_ROW_SMALL_SCREEN = 2
BOXES_PER_ROW_MEDIUM_SCREEN = 3

elTopPosition = ($el) ->
  if $el
  then $el.offsetTop + elTopPosition($el.offsetParent)
  else 0

module.exports = class GameResults
  constructor: ({featuredGameRow} = {}) ->
    styles.use()

    featuredGameRow ?= 0

    @gameLinks = []

    if window.matchMedia('(min-width: 360px)').matches
      @gameBoxSize = 100
      @gamePromoWidth = 320
      @gamePromoHeight = 204
      @featuredGamePosition = featuredGameRow * BOXES_PER_ROW_MEDIUM_SCREEN
    else
      @gameBoxSize = 135
      @gamePromoWidth = 280
      @gamePromoHeight = 178
      @featuredGamePosition = featuredGameRow * BOXES_PER_ROW_SMALL_SCREEN

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

    Game.getTop
      limit: LOAD_MORE_GAMES_LIMIT
      skip: @gameLinks.length
    .then (games) =>
      @gameLinks = @gameLinks.concat _.map games, (game, index) =>
        if index is @featuredGamePosition
          type: 'featured'
          component: new GamePromo(
            {game, width: @gamePromoWidth, height: @gamePromoHeight}
          )
        else
          type: 'default', component: new GameBox {game, iconSize: @gameBoxSize}

      @isLoading = false

      # TODO: (Zoli) force redraw once Zorium batches draws
      z.redraw()

      # Stop loading more
      if _.isEmpty games
        return true

  render: =>
    z 'section.z-game-results',
      z 'div.l-content-container',
        z 'h2.z-game-results-header', 'Most popular games'
          z 'div.z-game-results-game-boxes',
          (_.map @gameLinks, (gameLink) ->
            if gameLink.type is 'featured'
              z '.z-game-results-featured-game-box-container',
                gameLink.component
            else
              z '.z-game-results-game-box-container',
                gameLink.component
          ).concat [
            if @isLoading then z '.z-game-results-spinner', @Spinner
          ]
