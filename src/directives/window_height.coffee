module.exports = class WindowHeightDir
  resize: ->
    @$el?.style.height = window.innerHeight + 'px'

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    @$el = $el

    # Bind event listeners
    window.addEventListener 'resize', @resize

    ctx.onunload = =>
      window.removeEventListener 'resize', @resize


    @resize()
