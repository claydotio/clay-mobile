z = require 'zorium'
_ = require 'lodash'
Dropzone = require 'dropzone'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

renderLoadingCanvas = (ctx, {size, percentUploaded}) ->
  lineWidth = 3
  pixelRatioSize = size * window.devicePixelRatio

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


module.exports = class UploaderBase
  constructor: (
    {
      inputName
      url
      method
      @o_uploadedObj
      @o_hasUploaded
      width
      height
      loadingCircleDiameter
    }
  ) ->
    styles.use()

    method ?= 'put'
    loadingCircleDiameter ?= height

    @state = z.state {
      percentUploaded: z.observe 0
      isLoading: false
      thumbnail: null
      loadingCircleDiameter
      inputName
      url
      method
      width
      height
    }

  onMount: ($el) =>
    {
      url
      method
      acceptedFileTypes
      width
      height
      loadingCircleDiameter
      inputName
    } = @state()

    $loadingCanvas = $el.children[0]
    loadingCanvasCtx = $loadingCanvas.getContext '2d'
    pixelRatioSize = loadingCircleDiameter * window.devicePixelRatio
    # change center
    loadingCanvasCtx.translate pixelRatioSize / 2, pixelRatioSize / 2
    loadingCanvasCtx.rotate (-1 / 2) * Math.PI # rotate -90 deg

    @state.percentUploaded (percentUploaded) ->
      renderLoadingCanvas loadingCanvasCtx, {
        percentUploaded
        size: loadingCircleDiameter
      }

    # override the default listeners that do styling
    # so we can use our own rendering system
    # http://stackoverflow.com/questions/18645945/override-default-event-listeners-in-dropzone-js
    dropzone = new Dropzone $el, {
      url: url
      method: method
      paramName: inputName
      acceptedFiles: acceptedFileTypes
      thumbnailWidth: width
      thumbnailHeight: height
      addedfile: =>
        @state.set isLoading: true
      success: (file, res) =>
        @state.set isLoading: false
        @o_uploadedObj?.set res
        @o_hasUploaded?.set true
      error: (file, res) =>
        @state.set isLoading: false
        # TODO: (Austin) better error handling UX
        alert "Error: #{res.detail}"

      uploadprogress: (file, percentUploaded) =>
        @state.percentUploaded.set percentUploaded

      thumbnail: (file, dataUrl) =>
        @state.set thumbnail: dataUrl
      }

  getDropzone$: -> null

  render: ({isLoading, width, height, loadingCircleDiameter}) =>
    z "div.z-uploader-base#{if isLoading then '.is-loading' else ''}", {
      style:
        width: "#{width}px"
        height: "#{height}px"
      },
      z 'canvas.loading-canvas',
        if width
          width: loadingCircleDiameter * window.devicePixelRatio
          height: loadingCircleDiameter * window.devicePixelRatio
          style:
            width: "#{loadingCircleDiameter}px"
            height: "#{loadingCircleDiameter}px"
            left: '50%'
            marginLeft: -1 * loadingCircleDiameter / 2 + 'px'
            top: '50%'
            marginTop: -1 * loadingCircleDiameter / 2 + 'px'
      @getDropzone$()
