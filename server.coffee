express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
url = require 'url'
_ = require 'lodash'
Promise = require 'bluebird'
request = Promise.promisifyAll require 'request'
useragent = require 'express-useragent'
compress = require 'compression'
log = require 'loglevel'
cookieParser = require 'cookie-parser'
rp = require 'request-promise'

config = require './src/config'

API_REQUEST_TIMEOUT = 1000 # 1 second
HEALTHCHECK_TIMEOUT = 200

router = express.Router()
log.enableAll()

# Dust templates
# Don't compact whitespace, because it breaks the javascript partial
dust.optimizers.format = (ctx, node) -> node

indexTpl = dust.compile fs.readFileSync('index.dust', 'utf-8'), 'index'


distJs = if config.ENV is config.ENVS.PROD \
          then fs.readFileSync('dist/js/bundle.js', 'utf-8')
          else null
distCss = if config.ENV is config.ENVS.PROD \
          then fs.readFileSync('dist/css/bundle.css', 'utf-8')
          else null

dust.loadSource indexTpl

# Middlewares
clayUserSessionMiddleware = ->
  (req, res, next) ->
    req.clay = {}
    req.clay.me = null

    # Don't inject anything for kik, it will use kikAnonToken
    # They delete cookies all the time, inflating signup metrics
    if req.useragent.isProbablyKik
      return next()

    loginUrl = config.CLAY_API_URL + '/users/login/anon'
    meUrl = config.CLAY_API_URL + '/users/me'
    accessToken = req.cookies.accessToken

    # Don't inject user because the page is sent over http
    if accessToken
      return next()
    else
      isSubdomain = req.headers.host isnt config.HOST
      if isSubdomain
        return next()

      request.postAsync loginUrl
      .timeout API_REQUEST_TIMEOUT
      .spread (res, body) ->
        req.clay.me = JSON.parse body
        next()
      .catch (err) ->
        log.trace err
        next()

clayFlakCannonSessionMiddleware = ->
  (req, res, next) ->
    me = req.clay?.me
    req.clay.experiments = null
    unless me
      return next()

    experimentsUrl = config.FC_API_URL + '/experiments'
    request.postAsync experimentsUrl,
      {json: userId: me.id}
    .timeout API_REQUEST_TIMEOUT
    .spread (res, body) ->
      req.clay.experiments = body
      next()
    .catch (err) ->
      log.trace err
      next()

isKikUseragentMiddleware = ->
  (req, res, next) ->
    {source, isMac, isSafari, isMobile} = req.useragent

    isKik = /^Kik/.test source
    isKikBot = /KikBot/.test source
    isiOSWebView = isMac and not isSafari and isMobile

    req.useragent.isProbablyKik = isKik or isKikBot or isiOSWebView

    next()

app = express()

app.use compress()
if config.ENV is config.ENVS.PROD
then app.use express['static'](__dirname + '/dist')
else app.use express['static'](__dirname + '/build')

# After checking static files
app.use cookieParser()
app.use useragent.express()
app.use isKikUseragentMiddleware()
app.use clayUserSessionMiddleware()
app.use clayFlakCannonSessionMiddleware()
app.use router


# Development
unless config.ENV is config.ENVS.PROD
  # fb-flo - for live reload
  flo = require('fb-flo')
  fs = require('fs')

  flo 'build',
    port: 8888
    host: 'localhost'
    verbose: false
    glob: [
      'js/bundle.js'
      'css/bundle.css'
    ]
  , (filepath, callback) ->
    callback
      resourceURL: filepath
      contents: fs.readFileSync('build/' + filepath, 'utf-8').toString()


# Routes
router.get '/healthcheck', (req, res) ->
  Promise.settle [
      Promise.cast(rp(config.CLAY_API_URL + '/ping'))
        .timeout HEALTHCHECK_TIMEOUT
      Promise.cast(rp(config.FC_API_URL + '/ping'))
        .timeout HEALTHCHECK_TIMEOUT
    ]
    .spread (clayApi, flakCannon) ->
      res.json
        clayApi: clayApi.isFulfilled()
        flakCannon: flakCannon.isFulfilled()
        healthy: clayApi.isFulfilled() and flakCannon.isFulfilled()

router.get '/game/:key', (req, res) ->
  log.info 'AGENT ', req.useragent.source
  gameKey = req.params.key

  renderGamePage gameKey, req.clay.me, req.clay.experiments
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err

    renderHomePage(req.clay.me, req.clay.experiments)
    .then (html) ->
      res.send html
    .catch (err) ->
      log.trace err
      res.status(500).send()

router.get '*', (req, res) ->
  log.info 'AGENT ', req.useragent.source
  host = req.headers.host

  # Game Subdomain - 0.0.0.0 used when running tests locally
  if host isnt config.HOST and host isnt '0.0.0.0'
    gameKey = host.split('.')[0]

    return renderGamePage gameKey, req.clay.me, req.clay.experiments
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err
        renderHomePage(req.clay.me, req.clay.experiments)
        .then (html) ->
          res.send html
        .catch (err) ->
          log.trace err
          res.status(500).send()

  renderHomePage(req.clay.me, req.clay.experiments)
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err
    res.status(500).send()

# Cache rendering
renderHomePage = do ->
  page =
    inlineSource: config.ENV is config.ENVS.PROD
    webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
    title: 'Free Games'
    description: 'Play mobile games on your phone for free.
                  We bring you the best mobile web games.'
    keywords: 'mobile games, phone games, free mobile games, mobile web games'
    name: 'Clay.io'
    icon256: '//cdn.wtf/d/images/icons/icon_256.png'
    icon76: '//cdn.wtf/d/images/icons/icon_76.png'
    icon120: '//cdn.wtf/d/images/icons/icon_120.png'
    icon152: '//cdn.wtf/d/images/icons/icon_152.png'
    icon440x280: '//cdn.wtf/d/images/icons/icon_440_280.png'
    iconKik: '//cdn.wtf/d/images/icons/icon_256_orange.png'
    url: 'http://clay.io/'
    canonical: 'http://clay.io'
    me: 'REPLACE_WITH_ME'
    experiments: 'REPLACE_WITH_EXPERIMENTS'
    distjs: distJs
    distcss: distCss

  rendered = Promise.promisify(dust.render, dust) 'index', page

  (me, experiments) ->
    rendered.then (html) ->
      html.replace 'REPLACE_WITH_ME', JSON.stringify me
      .replace 'REPLACE_WITH_EXPERIMENTS', JSON.stringify experiments

renderGamePage = (gameKey, me, experiments) ->

  gameUrl = config.CLAY_API_URL + "/games/findOne?key=#{gameKey}"

  log.info 'GET', gameUrl
  request.getAsync gameUrl
  .timeout API_REQUEST_TIMEOUT
  .spread (res, body) ->
    game = JSON.parse body
    if _.isEmpty game
      throw new Error 'Game not found: ' + gameKey

    page =
      inlineSource: config.ENV is config.ENVS.PROD
      webpackDevHostname: config.WEBPACK_DEV_HOSTNAME
      title: "#{game.name}"
      description: "Play #{game.name}; #{game.description}"
      keywords: "#{game.name}, mobile games,  free mobile games"
      name: "#{game.name} - Clay.io"
      distjs: distJs
      distcss: distCss

      # TODO: (Zoli) This isn't good enough
      icon256: game.icon128Url
      icon76: game.icon128Url
      icon120: game.icon128Url
      icon152: game.icon128Url
      iconKik: game.icon128Url

      # TODO: (Zoli) this should be returned by the server
      icon440x280: "http://cdn.wtf/g/#{game.id}/meta/promo_440.png"
      url: "http://#{game.key}.clay.io"
      canonical: "http://#{game.key}.clay.io"

      me: JSON.stringify me
      experiments: JSON.stringify experiments

    Promise.promisify(dust.render, dust) 'index', page

module.exports = app
