z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

GameFilter = require '../../models/game_filter'
GameBox = require '../game_box'
Spinner = require '../spinner'

styles = require './index.styl'

LOAD_MORE_GAMES_LIMIT = 10
SCROLL_THRESHOLD = 250

elTopPosition = ($el) ->
  if $el
  then $el.offsetTop + elTopPosition($el.offsetParent)
  else 0

module.exports = class GameResults
  constructor: ->
    styles.use()

    @gameBoxes = []
    @gameBoxSize = 128

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
      skip: @gameBoxes.length
    .then (games) =>
      @gameBoxes = @gameBoxes.concat _.map games, (game) =>
        new GameBox {game, @gameBoxSize}

      @isLoading = false

      # TODO: (Zoli) force redraw once Zorium batches draws
      z.redraw()

      # Stop loading more
      if _.isEmpty games
        return true

  render: =>
    z 'section.game-results',
    (_.map @gameBoxes, (gameBox) ->
      z '.game-results-box-container', [
        gameBox
      ]
    ).concat [
      if @isLoading then z '.game-results-spinner', @Spinner
    ]
