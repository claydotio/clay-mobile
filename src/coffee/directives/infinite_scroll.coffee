log = require 'clay-loglevel'

SCROLL_THRESHOLD = 250

elTopPosition = ($el) ->
  if $el
  then $el.offsetTop + elTopPosition($el.offsetParent)
  else 0

module.exports = class InfiniteScrollDir
  constructor: ({@loadMore}) ->
    @isListening = true

  scrollListener: =>
    unless @isListening
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
      @isListening = false

      return @loadMore().then (shouldStop) =>
        unless shouldStop
          @isListening = true
          return @scrollListener()
      .catch log.trace

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    @$el = $el

    # Bind event listeners
    window.addEventListener 'scroll', @scrollListener
    window.addEventListener 'resize', @scrollListener

    ctx.onunload = =>
      window.removeEventListener 'scroll', @scrollListener
      window.removeEventListener 'resize', @scrollListener


    @scrollListener()
