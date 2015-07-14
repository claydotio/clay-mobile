Vibrant = require 'vibrant'
Vibrant = window.Vibrant # FIXME

PortalService = require './portal'
Game = require '../models/game'

styleConfig = require '../stylus/vars.json'

tweet = (text) ->
  text = encodeURIComponent text.substr 0, 140
  window.open "https://twitter.com/intent/tweet?text=#{text}"

roundRect = (ctx, x, y, width, height, radius, fill, stroke) ->
  if typeof stroke == 'undefined'
    stroke = true
  if typeof radius == 'undefined'
    radius = 5
  ctx.beginPath()
  ctx.moveTo x + radius, y
  ctx.lineTo x + width - radius, y
  ctx.quadraticCurveTo x + width, y, x + width, y + radius
  ctx.lineTo x + width, y + height - radius
  ctx.quadraticCurveTo x + width, y + height, x + width - radius, y + height
  ctx.lineTo x + radius, y + height
  ctx.quadraticCurveTo x, y + height, x, y + height - radius
  ctx.lineTo x, y + radius
  ctx.quadraticCurveTo x, y, x + radius, y
  ctx.closePath()
  if stroke
    ctx.stroke()
  if fill
    ctx.fill()


# http://www.html5canvastutorials.com/tutorials/
#   html5-canvas-wrap-text-tutorial/
wrapText = (ctx, text, x, y, maxWidth, lineHeight) ->
  words = text.split(' ')
  line = ''
  n = 0
  while n < words.length
    testLine = line + words[n] + ' '
    metrics = ctx.measureText(testLine)
    testWidth = metrics.width
    if testWidth > maxWidth and n > 0
      ctx.fillText line, x, y

      line = words[n] + ' '
      y += lineHeight
    else
      line = testLine
    n += 1
  ctx.fillText line, x, y

truncate = (str, length) ->
  if str.length > length then str.substr(0, length - 1) + '...' else str

loadImage = (src) ->
  new Promise (resolve) ->
    # if image is loaded via browser cache, it doesn't work with cors
    src += '?' + Date.now()
    $$img = new Image()
    $$img.setAttribute 'crossOrigin', 'anonymous'
    $$img.src = src
    $$img.addEventListener 'load', ->
      resolve $$img

generateCard = (icon, headerImage, title, text) ->
  $$canvas = document.createElement 'canvas'
  $$canvas.width = 512
  $$canvas.height = 464
  ctx = $$canvas.getContext '2d'
  Promise.all [
    loadImage icon
    loadImage headerImage
  ]
  .then ([$$icon, $$headerImage]) ->
    # 2:1
    vibrant = new Vibrant $$headerImage
    swatches = vibrant.swatches()
    color = swatches.DarkVibrant or swatches.Vibrant or swatches.DarkMuted or
            swatches.$blueGrey500

    # header
    baseHeaderHeight = 256
    headerHeight = baseHeaderHeight
    yOffset = 0
    headerWidth = $$headerImage.width * headerHeight / $$headerImage.height
    if headerWidth < $$canvas.width
      headerWidth = $$canvas.width
      headerHeight = $$headerImage.height * headerWidth / $$headerImage.width
      yOffset = -1 * (headerHeight - baseHeaderHeight) / 2

    xOffset = -1 * (headerWidth / 2) + $$canvas.width / 2
    ctx.drawImage $$headerImage, xOffset, yOffset, headerWidth, headerHeight
    iconWidth = 100
    iconHeight = 100
    iconYOffset = 228
    iconStroke = 4
    cornerRadius = 3
    iconXPadding = 30
    titleYPadding = 16
    titleFontSize = 42
    textYPadding = 30
    textFontSize = 20
    textLineHeight = 24
    textMaxChars = 120

    # bg color
    ctx.save()
    ctx.beginPath()
    ctx.fillStyle = color.getHex()
    ctx.rect 0, baseHeaderHeight, $$canvas.width,
             $$canvas.height - baseHeaderHeight
    ctx.shadowColor = 'rgba(0, 0, 0, 0.3)'
    ctx.shadowBlur = 6
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = -2
    ctx.fill()
    ctx.closePath()
    ctx.restore()

    # icon
    # shadow
    ctx.save()
    ctx.beginPath()
    ctx.fillStyle = color.getHex()
    ctx.rect iconXPadding - iconStroke / 2,
              iconYOffset - iconStroke / 2 + cornerRadius,
              iconWidth + iconStroke, iconHeight + iconStroke - cornerRadius
    ctx.shadowColor = 'rgba(0, 0, 0, 0.3)'
    ctx.shadowBlur = 6
    ctx.shadowOffsetX = 0
    ctx.shadowOffsetY = 2
    ctx.closePath()
    ctx.fill()
    ctx.restore()
    # white bg for rounded icons
    ctx.fillStyle = styleConfig.$white
    ctx.fillRect iconXPadding + iconStroke / 2,
                  iconYOffset + iconStroke / 2, iconWidth - iconStroke,
                  iconHeight - iconStroke
    # image
    ctx.drawImage $$icon, iconXPadding + iconStroke / 2,
                  iconYOffset + iconStroke / 2, iconWidth - iconStroke,
                  iconHeight - iconStroke
    # border
    ctx.lineWidth = iconStroke
    ctx.strokeStyle = styleConfig.$white
    roundRect ctx, iconXPadding, iconYOffset, iconWidth, iconHeight,
              cornerRadius, false, true

    # title
    ctx.font = "#{titleFontSize}px 'Roboto'"
    ctx.fillStyle = styleConfig.$white
    ctx.fillText title, iconXPadding * 2 + iconWidth,
                  baseHeaderHeight + titleYPadding + titleFontSize

    # text
    ctx.font = "bold #{textFontSize}px 'Roboto'"
    wrapText ctx, truncate(text, textMaxChars), iconXPadding,
              iconYOffset + iconHeight + textYPadding + textFontSize,
              $$canvas.width - iconXPadding * 2, textLineHeight
    $$canvas.toDataURL()

class ShareService
  any: ({text, game}) ->
    if game
      icon = Game.getIconUrl game
      headerImage = Game.getHeaderImageUrl game
      title = game.name
      description = game.description
      cardPromise = generateCard icon, headerImage, title, description
    else
      cardPromise = Promise.resolve null

    gameId = game?.id or 1

    cardPromise.then (cardDataUrl) ->
      PortalService.call 'share.any',
        data:
          gameKey: game?.key
        context: 'compose'
        gameId: gameId
        cardDataUrl: cardDataUrl
        text: text
      .catch (err) ->
        tweet text

module.exports = new ShareService()
