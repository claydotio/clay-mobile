z = require 'zorium'
_ = require 'lodash'
Dropzone = require 'dropzone'

styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'

styles = require './index.styl'

LOADING_CANVAS_SIZE_PX = 80

createLoadingCanvas = ($parent) ->
  loadingCanvas = document.createElement 'canvas'
  loadingCanvas.width = loadingCanvas.height =
    LOADING_CANVAS_SIZE_PX * window.devicePixelRatio
  loadingCanvas.style.width = loadingCanvas.style.height =
    "#{LOADING_CANVAS_SIZE_PX}px"
  loadingCanvas.style.left = '50%'
  loadingCanvas.style.marginLeft = -1 * LOADING_CANVAS_SIZE_PX / 2 + 'px'
  loadingCanvas.style.top = '50%'
  loadingCanvas.style.marginTop = -1 * LOADING_CANVAS_SIZE_PX / 2 + 'px'

  $parent.appendChild loadingCanvas
  return loadingCanvas

renderLoadingCanvas = (ctx, percentUploaded) ->
  lineWidth = 3
  pixelRatioSize = LOADING_CANVAS_SIZE_PX * window.devicePixelRatio

  ctx.translate pixelRatioSize / 2, pixelRatioSize / 2 # change center
  ctx.rotate (-1 / 2) * Math.PI # rotate -90 deg

  #imd = ctx.getImageData(0, 0, 240, 240);
  radius = (pixelRatioSize - lineWidth) / 2
  drawCircle = (color, lineWidth, percent) ->
    percent = Math.min(Math.max(0, percent or 1), 1)
    ctx.beginPath()
    ctx.arc 0, 0, radius, 0, Math.PI * 2 * percent, false
    ctx.strokeStyle = color
    ctx.lineCap = 'square' # butt, round or square
    ctx.lineWidth = lineWidth
    ctx.stroke()
    return

  drawCircle styleConfig.$green, lineWidth, percentUploaded / 100


module.exports = class ImageUploader
  constructor: (
    {
      inputName
      label
      url
      method
      thumbnail
      renderHeight
      width
      height
      safeWidth
      safeHeight
    }
  ) ->
    styles.use()

    label ?= ''
    method ?= 'put'
    safeWidth ?= width
    safeHeight ?= height
    # scaled per design specs, not full-size images
    renderScale = renderHeight / height
    renderWidth = width * renderScale
    renderSafeWidth = safeWidth * renderScale
    renderSafeHeight = safeHeight * renderScale

    @state = z.state {
      percentUploaded: 0
      loading: false
      thumbnail
      inputName
      label
      url
      method
      width
      height
      renderHeight
      renderWidth
      safeWidth
      safeHeight
      renderSafeWidth
      renderSafeHeight
    }

  onMount: ($el) =>

    loadingCanvas = createLoadingCanvas $el

    # override the default listeners that do styling
    # so we can use our own rendering system
    # http://stackoverflow.com/questions/18645945/override-default-event-listeners-in-dropzone-js
    User.getMe().then ({accessToken}) =>
      dropzone = new Dropzone $el, {
        url: "#{@state().url}?accessToken=#{accessToken}"
        method: @state().method
        paramName: @state().inputName
        acceptedFiles: 'image/*'
        thumbnailWidth: @state().renderWidth
        thumbnailHeight: @state().renderHeight
        addedfile: =>
          @state.set loading: true
        complete: =>
          @state.set loading: false

        uploadprogress: (file, percentUploaded) =>
          @state.set {percentUploaded}
          renderLoadingCanvas loadingCanvas.getContext('2d'), percentUploaded

        thumbnail: (file, dataUrl) =>
          @setThumbnail dataUrl
      }

  setThumbnail: (url) =>
    @state.set thumbnail: url

  render: (
    {
      loading
      renderWidth
      renderHeight
      percentUploaded
      label
      thumbnail
      safeHeight
      safeWidth
      width
      height
      renderSafeWidth
      renderSafeHeight
    }
  ) ->
    z "div.z-image-uploader#{if loading then '.is-loading' else ''}",
      {
        style:
          width: "#{renderWidth}px"
          height: "#{renderHeight}px"
      },
      # .dz-message necessary to be clickable (no workaround)
      z 'div.dz-message.clickable',
        z 'div.l-flex.l-vertical-center',
          z 'div.content.percentage',
            "#{percentUploaded}%"
          z 'div.content.drop-here',
            z 'div', '+'
            z 'div', label
            z 'div', 'Drop here'

      if thumbnail
        z 'div.thumbnail',
          z 'a.close[href=#]',
            onclick: (e) =>
              e.preventDefault()
              # FIXME
              @setThumbnail(null)
            z 'i.icon.icon-close'
          z "img[src=#{thumbnail}]"
          if safeWidth isnt width or
             safeHeight isnt height
            z 'div',
              z 'div.unsafe-overlay'
              z 'div.safe',
                {
                  style:
                    width: "#{renderSafeWidth}px"
                    height: "#{renderSafeHeight}px"
                    left: '50%'
                    marginLeft: -1 * renderSafeWidth / 2 + 'px'
                    top: '50%'
                    marginTop: -1 * renderSafeHeight / 2 + 'px'
                },
                z 'div.safe-text', 'Safe zone'
                z "img[src=#{thumbnail}]",
                  {
                    style:
                      marginLeft: -1 * (renderWidth - renderSafeWidth) /
                        2 + 'px'
                      marginTop: -1 * (renderHeight - renderSafeHeight) /
                        2 + 'px'
                  }
