z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
User = require '../../models/user'
Modal = require '../../models/modal'
GameBox = require '../game_box'
GamePromo = require '../game_promo'
Spinner = require '../spinner'
FirstVisitModal = require '../first_visit_modal'

styles = require './index.styl'

# loading 13 at a time lets the featured images load in the right position for
# each batch. 12 (least common multiple of 2, 3) normal images + 1 featured
LOAD_MORE_GAMES_LIMIT = 13
SCROLL_THRESHOLD = 250
BOXES_PER_ROW_SMALL_SCREEN = 2
BOXES_PER_ROW_MEDIUM_SCREEN = 3

elTopPosition = ($$el) ->
  if $$el
  then $$el.offsetTop + elTopPosition($$el.offsetParent)
  else 0

module.exports = class PopularGames
  constructor: ({featuredGameRow} = {}) ->
    styles.use()

    featuredGameRow ?= 0

    if window.matchMedia('(min-width: 360px)').matches
      gameBoxSize = 98
      modalGameBoxSize = 118
      gamePromoWidth = 328
      gamePromoHeight = 209
      featuredGamePosition = featuredGameRow * BOXES_PER_ROW_MEDIUM_SCREEN
    else
      gameBoxSize = 136
      modalGameBoxSize = 108
      gamePromoWidth = 288
      gamePromoHeight = 183
      featuredGamePosition = featuredGameRow * BOXES_PER_ROW_SMALL_SCREEN

    @isListeningForScroll = true

    User.getVisitCount()
    .then (visitCount) ->
      if visitCount is 1 and not User.getViewedFirstVisitModalThisSession()
        User.setViewedFirstVisitModalThisSession true
        Modal.openComponent
          component: new FirstVisitModal
            gameBoxSize: modalGameBoxSize
    .catch log.trace

    @state = z.state {
      $spinner: new Spinner()
      isLoading: true
      gameLinks: []
      gameBoxSize
      gamePromoWidth
      gamePromoHeight
      featuredGamePosition
    }

  onMount: (@$$el) =>
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
    $$el = @$$el

    scrollTop = window.pageYOffset
    scrollTop ?= document.documentElement.scrollTop
    scrollTop ?= document.body.parentNode.scrollTop
    scrollTop ?= document.body.scrollTop

    totalScrolled = elTopPosition($$el) + $$el.offsetHeight
    totalScrollHeight = scrollTop + window.innerHeight

    if totalScrolled - totalScrollHeight < SCROLL_THRESHOLD
      @isListeningForScroll = false

      return @loadMore().then (shouldStop) =>
        unless shouldStop
          @isListeningForScroll = true
          return @scrollListener()
      .catch log.trace

  loadMore: =>
    {gameLinks, featuredGamePosition} = @state()

    @state.set isLoading: true
    z.redraw()

    Game.getTop
      limit: LOAD_MORE_GAMES_LIMIT
      skip: gameLinks.length
    .then (games) =>
      @state.set
        isLoading: false
        gameLinks: gameLinks.concat _.map games, (game, index) ->
          if index is featuredGamePosition
            type: 'featured'
            game: game
            $component: new GamePromo()
          else
            type: 'default'
            game: game
            $component: new GameBox()

      # TODO: (Zoli) force redraw once Zorium batches draws

      # Stop loading more
      if _.isEmpty games
        return true

  render: =>
    {
      gameLinks
      $spinner
      gamePromoWidth
      gamePromoHeight
      gameBoxSize
      isLoading
    } = @state()

    z 'section.z-game-results',
      z 'h2.header', 'Most popular games'
      z 'div.game-boxes',
      (_.map gameLinks, (gameLink) ->
        if gameLink.type is 'featured'
          z '.featured-game-box-container',
            z gameLink.$component,
              game: gameLink.game
              width: gamePromoWidth
              height: gamePromoHeight
        else
          z '.game-box-container',
            z gameLink.$component,
              game: gameLink.game
              iconSize: gameBoxSize
      ).concat [
        if isLoading then z '.spinner', $spinner
      ]
