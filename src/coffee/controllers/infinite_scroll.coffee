SCROLL_THRESHOLD = 250

module.exports = class InfiniteScrollView
  elTopPosition = ($el) ->
    if $el
    then $el.offsetTop + @elTopPosition($el.offsetParent)
    else 0

  scrollListener = =>
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
      isListening = false

      @loadMore().then ->
        isListening = true
        scrollListener()


  constructor: ({@loadMore}) ->
    @isListening = true

  config: ($el, isInit) =>

    # run once
    if isInit
      return

    @$el = $el

    # Bind event listeners
    window.addEventListener 'scroll', scrollListener
    window.addEventListener 'resize', scrollListener

    scrollListener()
