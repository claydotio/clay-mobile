z = require 'zorium'
_ = require 'lodash'
Dropzone = require 'dropzone'

styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'

styles = require './index.styl'

LOADING_CANVAS_SIZE_PX = 320

createLoadingCanvas = ($parent) ->
  loadingCanvas = document.createElement 'canvas'
  loadingCanvas.width = loadingCanvas.height =
    LOADING_CANVAS_SIZE_PX * window.devicePixelRatio
  loadingCanvas.style.width = loadingCanvas.style.height =
    "#{LOADING_CANVAS_SIZE_PX}px"

  ctx = loadingCanvas.getContext '2d'
  pixelRatioSize = LOADING_CANVAS_SIZE_PX * window.devicePixelRatio
  ctx.translate pixelRatioSize / 2, pixelRatioSize / 2 # change center
  ctx.rotate (-1 / 2) * Math.PI # rotate -90 deg

  $parent.appendChild loadingCanvas
  return loadingCanvas

renderLoadingCanvas = (ctx, percentUploaded) ->
  lineWidth = 3
  pixelRatioSize = LOADING_CANVAS_SIZE_PX * window.devicePixelRatio

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


module.exports = class ZipUploader
  constructor: ({url, inputName, @onchange}) ->
    styles.use()

    @state = z.state {
      percentUploaded: 0
      loading: false
      url
      inputName
    }


  onMount: ($el) =>
    loadingCanvas = createLoadingCanvas $el

    # override the default listeners that do styling
    # so we can use our own rendering system
    # http://stackoverflow.com/questions/18645945/override-default-event-listeners-in-dropzone-js
    User.getMe().then ({accessToken}) =>
      dropzone = new Dropzone $el, {
        url: "#{@state().url}?accessToken=#{accessToken}"
        method: 'put'
        paramName: @state().inputName
        acceptedFiles: 'application/zip,' +
                       'application/x-zip-compressed,' +
                       'application/octet-stream'
        addedfile: =>
          @state.set loading: true
        success: (fie, res) =>
          @state.set loading: false
          @onchange? true
        error: (File, res) =>
          @state.set loading: false
          # TODO: (Austin) better error handling UX
          alert "Error: #{res.detail}"

        uploadprogress: (file, percentUploaded) =>
          @state.set {percentUploaded}
          renderLoadingCanvas loadingCanvas.getContext('2d'), percentUploaded
      }

  render: ->
    z 'div.z-zip-uploader',
      # .dz-message necessary to be clickable (no workaround)
      z 'div.upload-dropzone.dz-message.l-flex.l-vertical-center',
        z 'div.upload-content',
          z 'i.icon.icon-cloud-upload'
          z 'div.drop-here', 'Drop your game .zip here'
          z.router.link z 'a[href=#].browse', 'or browse'
