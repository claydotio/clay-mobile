express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
_ = require 'lodash'
Promise = require 'bluebird'
useragent = require 'express-useragent'
compress = require 'compression'
log = require 'loglevel'
cookieParser = require 'cookie-parser'
request = require 'request-promise'
helmet = require 'helmet'

config = require './src/config'

API_REQUEST_TIMEOUT = 1000 # 1 second
HEALTHCHECK_TIMEOUT = 1000
EIGHTEEN_WEEKS_MS = 10886400000 # 18 weeks
KIK_DESCRIPTION_MAX_CHARS = 500
KIK_DESCRIPTION_VISIBLE_CHARS = 100

router = express.Router()
log.enableAll()

# Dust templates
# Don't compact whitespace, because it breaks the javascript partial
dust.optimizers.format = (ctx, node) -> node

indexTpl = dust.compile fs.readFileSync('index.dust', 'utf-8'), 'index'


distJs = if config.ENV is config.ENVS.PROD \
          then fs.readFileSync('dist/js/bundle.js', 'utf-8')
          else null

dust.loadSource indexTpl

isKikUseragentMiddleware = ->
  (req, res, next) ->
    {source, isMac, isSafari, isMobile} = req.useragent

    isKik = /Kik/.test source
    isiOSWebView = isMac and not isSafari and isMobile

    req.useragent.isProbablyKik = isKik or isiOSWebView

    next()

# coffeelint: disable=missing_fat_arrows
Error404 = (message) ->
  @name = 'Error404'
  @message = message
  @stack = (new Error()).stack
Error404.prototype = new Error()
# coffeelint: enable=missing_fat_arrows

app = express()

app.use compress()

if config.ENV is config.ENVS.PROD
then app.use express.static(__dirname + '/dist', {maxAge: '4h'})
else app.use express.static(__dirname + '/build', {maxAge: '4h'})

# Security
webpackDevHost = config.WEBPACK_DEV_HOSTNAME + ':' + config.WEBPACK_DEV_PORT
scriptSrc = [
  '\'unsafe-eval\''
  '\'unsafe-inline\''
  'cdn.wtf'
  'www.google-analytics.com'
  'cdn.kik.com'
  if config.ENV is config.ENVS.DEV then webpackDevHost

]
stylesSrc = [
  '\'unsafe-inline\''
  if config.ENV is config.ENVS.DEV then webpackDevHost
]
# FIXME: disabled for kik
# app.use helmet.contentSecurityPolicy
#   scriptSrc: scriptSrc
#   stylesSrc: stylesSrc
app.use helmet.xssFilter()

# Some security options are only enabled for the developer site
app.use (req, res, next) ->
  if req.headers.host is config.DEV_HOST
    frameMiddleware = helmet.frameguard()
    hstsMiddleware = helmet.hsts
      # Must be at least 18 weeks to be approved by Google
      # https://hstspreload.appspot.com/
      maxAge: EIGHTEEN_WEEKS_MS
      # required for Google approval, but disabled because of this post
      # http://serverfault.com
      # /questions/482350/can-i-turn-on-hsts-for-1-subdomain
      #includeSubdomains: true
      preload: true # include in Google Chrome
      force: true

    return frameMiddleware req, res, (err) ->
      if err
        return next(err)

      return hstsMiddleware req, res, next
  return next()

app.disable 'x-powered-by'
app.use helmet.noSniff()
app.use helmet.crossdomain()

app.use cookieParser()
app.use useragent.express()
app.use isKikUseragentMiddleware()
app.use router

# Routes
# FIXME: Server-side rendering for SEO
router.get '/healthcheck', (req, res) ->
  Promise.settle [
      Promise.cast(request.get(config.CLAY_API_URL + '/ping'))
        .timeout HEALTHCHECK_TIMEOUT
    ]
    .spread (clayApi) ->
      res.json
        clayApi: clayApi.isFulfilled()
        healthy: clayApi.isFulfilled()

router.get '/ping', (req, res) ->
  res.end 'pong'

router.get '/game/:key', (req, res) ->
  gameKey = req.params.key

  renderGamePage gameKey, req.useragent.isProbablyKik
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err

    if err instanceof Error404 or err.statusCode is 404
      fourOhFour()
      .then (html) ->
        res.status(404).send html
      .catch (err) ->
        log.trace err
        res.status(500).send()
    else
      renderHomePage(req.useragent.isProbablyKik)
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err
        res.status(500).send()

router.get '/invite-landing/:fromUserId', (req, res) ->
  fromUserId = req.params.fromUserId

  renderInviteLandingPage fromUserId, req.useragent.isProbablyKik
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err

    if err instanceof Error404 or err.statusCode is 404
      fourOhFour()
      .then (html) ->
        res.status(404).send html
      .catch (err) ->
        log.trace err
        res.status(500).send()
    else
      renderHomePage(req.useragent.isProbablyKik)
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err
        res.status(500).send()

router.get '*', (req, res) ->
  host = req.headers.host

  # Game Subdomain - 0.0.0.0 used when running tests locally
  if host isnt config.HOST and host isnt config.DEV_HOST and host isnt '0.0.0.0'
    gameKey = host.split('.')[0]

    return renderGamePage gameKey, req.useragent.isProbablyKik
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err

        if err instanceof Error404 or err.statusCode is 404
          fourOhFour()
          .then (html) ->
            res.status(404).send html
          .catch (err) ->
            log.trace err
            res.status(500).send()
        else
          renderHomePage(req.useragent.isProbablyKik)
          .then (html) ->
            res.send html
          .catch (err) ->
            log.trace err
            res.status(500).send()

  renderHomePage(req.useragent.isProbablyKik)
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err
    res.status(500).send()

# Cache rendering
renderHomePage = do ->
  page =
    isProbablyKik: false
    inlineSource: config.ENV is config.ENVS.PROD
    webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
    title: 'Clay Games - Play Free HTML5 Mobile Games'
    description: 'Play mobile games instantly on your phone for free.
                  Clay has the best HTML5 games.'
    keywords: 'mobile games, clay games, free mobile games, mobile web games'
    name: 'Clay Games - Play Free HTML5 Mobile Games'
    icon256: 'https://cdn.wtf/d/images/icons/icon_256.png'
    icon76: 'https://cdn.wtf/d/images/icons/icon_76.png'
    icon120: 'https://cdn.wtf/d/images/icons/icon_120.png'
    icon152: 'https://cdn.wtf/d/images/icons/icon_152.png'
    icon440x280: 'https://cdn.wtf/d/images/icons/icon_440_280.png'
    iconKik: 'https://cdn.wtf/d/images/icons/icon_256_orange.png'
    url: 'https://clay.io/'
    canonical: 'https://clay.io'
    host: 'clay.io'
    distjs: distJs

  kikDescription = 'Play fun mobile games instantly on your phone for free.'
  kikKeywords = [
    'snapchat'
    'tinder'
    'facebook'
    'google'
    'twitter'
    'youtube'
    'vine'
    'instagram'
    'reddit'
    'kik'
    'tumblr'
    'hulu'

    'lucky'
    'candy'
    'angry'
    'flappy'
    'heyhey'
    'wouldya'
    'memes'
    'sketch'
    'stickers'
    'moco'
    'buzz'

    'boys'
    'girls'
    'cute'
    'gay'
    'lesbian'
    'meet'
    'love'
    'role'
    'play'
    'flirty'
    'hottest'
    'dates'
    'sexy'

    'kim'
    'beyonce'
    'taylor'
    'justin'
    'bieber'
    'miley'
    'katy'
    'selena'
    'nicki'

    'action'
    'adventure'
    'arcade'
    'board'
    'card'
    'casino'
    'casual'
    'music'
    'puzzle'
    'racing'
    'sim'
    'sports'
    'strategy'
    'trivia'
    'words'

    'gifs'
    'videos'
    'cats'
    'dogs'
    'friends'
    'chats'
    'pics'
    'funny'
    'talk'
    'quiz'
    'mix'
    'bored'
    'messages'
    'groups'
    'comment'
  ].join('')
  kikWhitespaceLength = KIK_DESCRIPTION_VISIBLE_CHARS - kikDescription.length
  kikWhitespace = _.repeat '_', kikWhitespaceLength

  kikPage = _.defaults
    isProbablyKik: true
    title: 'Free Games'
    description: (kikDescription + ' ' + kikWhitespace + kikKeywords)
                  .slice(0, KIK_DESCRIPTION_MAX_CHARS)
  , page

  rendered = Promise.promisify(dust.render, dust) 'index', page
  kikRendered = Promise.promisify(dust.render, dust) 'index', kikPage

  (isProbablyKik) -> if isProbablyKik then kikRendered else rendered

fourOhFour = do ->
  page =
    isProbablyKik: false
    inlineSource: config.ENV is config.ENVS.PROD
    webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
    title: 'Game not found - Clay Games'
    description: 'The HTML5 mobile game you are looking for could not be found'
    keywords: 'mobile games, clay games, free mobile games, mobile web games'
    name: 'Game not found - Clay Games'
    icon256: 'https://cdn.wtf/d/images/icons/icon_256.png'
    icon76: 'https://cdn.wtf/d/images/icons/icon_76.png'
    icon120: 'https://cdn.wtf/d/images/icons/icon_120.png'
    icon152: 'https://cdn.wtf/d/images/icons/icon_152.png'
    icon440x280: 'https://cdn.wtf/d/images/icons/icon_440_280.png'
    iconKik: 'https://cdn.wtf/d/images/icons/icon_256_orange.png'
    url: 'https://clay.io/404'
    canonical: 'https://clay.io/404'
    host: 'clay.io'
    distjs: distJs

  rendered = Promise.promisify(dust.render, dust) 'index', page

  -> rendered

renderGamePage = (gameKey, isProbablyKik) ->

  gameUrl = config.CLAY_API_URL + "/games/findOne?key=#{gameKey}"

  log.info 'GET', gameUrl
  Promise.cast request.get gameUrl
  .timeout API_REQUEST_TIMEOUT
  .then (body) ->
    game = JSON.parse body
    if _.isEmpty game
      throw new Error404 'Game not found: ' + gameKey

    # TODO: (Austin) use Game.getIcon() when zorium no longer depends on
    # DOM/window (Game model depends on Zorium)
    iconUrl = game.iconImage?.versions[0].url or game.icon128Url

    page =
      isProbablyKik: isProbablyKik
      inlineSource: config.ENV is config.ENVS.PROD
      webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
      title: if isProbablyKik \
             then "#{game.name}"
             else "#{game.name} - Clay Games Mobile HTML5"
      description: "Play #{game.name}; #{game.description}"
      keywords: "#{game.name}, mobile games,  free mobile games"
      name: "#{game.name} - Clay Games Mobile HTML5"
      distjs: distJs

      # TODO: (Zoli) This isn't good enough
      icon256: iconUrl
      icon76: iconUrl
      icon120: iconUrl
      icon152: iconUrl
      # Kik ignores icons that aren't over same protocol
      iconKik: iconUrl?.replace /^https?:/, ''

      # TODO: (Zoli) this should be returned by the server
      icon440x280: "https://cdn.wtf/g/#{game.id}/meta/promo_440.png"
      url: "https://#{game.key}.clay.io"
      canonical: "https://#{game.key}.clay.io"
      host: "#{game.key}.clay.io"

    Promise.promisify(dust.render, dust) 'index', page


renderInviteLandingPage = (fromUserId, isProbablyKik) ->

  page =
    isProbablyKik: isProbablyKik
    inlineSource: config.ENV is config.ENVS.PROD
    webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
    title: 'Please be my friend on Clay'
    description: 'Play a bunch of great games and be my friend on Clay'
    keywords: 'mobile games,  free mobile games'
    name: 'Please be my friend on Clay'
    distjs: distJs

    icon256: 'https://cdn.wtf/d/images/icons/icon_256.png'
    icon76: 'https://cdn.wtf/d/images/icons/icon_76.png'
    icon120: 'https://cdn.wtf/d/images/icons/icon_120.png'
    icon152: 'https://cdn.wtf/d/images/icons/icon_152.png'
    icon440x280: 'https://cdn.wtf/d/images/icons/icon_440_280.png'
    iconKik: '' # don't want this page to show on Kik
    url: "https://clay.io/invite-landing/#{fromUserId}"
    canonical: "https://clay.io/invite-landing/#{fromUserId}"
    host: 'clay.io'

  Promise.promisify(dust.render, dust) 'index', page

module.exports = app
