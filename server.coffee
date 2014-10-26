express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
request = require 'request'
url = require 'url'
_ = require 'lodash'
Promise = require 'bluebird'
useragent = require 'express-useragent'
compress = require 'compression'
log = require 'loglevel'
cookieParser = require 'cookie-parser'

config = require './src/coffee/config'

API_REQUEST_TIMEOUT_MS = 1000 # 1sec

router = express.Router()
log.enableAll()

# Dust templates
# Don't compact whitespace, because it breaks the javascript partial
dust.optimizers.format = (ctx, node) -> node

indexTpl = dust.compile fs.readFileSync('index.dust', 'utf-8'), 'index'

if config.ENV is config.ENVS.PROD
  distJs = dust.compile fs.readFileSync('dist/js/bundle.js', 'utf-8'), 'distjs'
  distCss = dust.compile fs.readFileSync('dist/css/bundle.css', 'utf-8'),
    'distcss'

  dust.loadSource distJs
  dust.loadSource distCss

dust.loadSource indexTpl


# TODO: (Zoli) make pretty
apiRequestUrl = (path) ->
  apiPath = url.parse config.API_PATH + '/'

  unless apiPath.hostname
    apiPath.hostname = config.HOSTNAME

  unless apiPath.protocol
    apiPath.protocol = 'http'

  url.format url.resolve url.format(apiPath), path

# Middlewares
claySessionParser = ->
  (req, res, next) ->
    req.clay = {}
    req.clay.me = null

    loginUrl = apiRequestUrl 'users/login/anon'
    meUrl = apiRequestUrl 'users/me'
    accessToken = req.cookies.accessToken

    if accessToken
      Promise.promisify(request.get, request) meUrl, {qs: {accessToken}}
      .timeout API_REQUEST_TIMEOUT_MS
      .spread (res, body) ->
        req.clay.me = JSON.parse body
        next()
      .catch (err) ->
        log.trace err

        # Getting user failed, create a new one
        Promise.promisify(request.post, request) loginUrl
        .timeout API_REQUEST_TIMEOUT_MS
        .spread (res, body) ->
          req.clay.me = JSON.parse body
          next()
        .catch (err) ->
          log.trace err
          next()
    else
      Promise.promisify(request.post, request) loginUrl
      .timeout API_REQUEST_TIMEOUT_MS
      .spread (res, body) ->
        req.clay.me = JSON.parse body
        next()
      .catch (err) ->
        log.trace err
        next()

app = express()

app.use compress()
if config.ENV is config.ENVS.PROD
then app.use express['static'](__dirname + '/dist')
else app.use express['static'](__dirname + '/build')

# After checking static files
app.use cookieParser()
app.use claySessionParser()
app.use useragent.express()
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
router.get '/game/:key', (req, res) ->
  log.info 'AGENT ', req.useragent.source
  gameKey = req.params.key

  renderGamePage gameKey, req.clay.me
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err

    renderHomePage(req.clay.me)
    .then (html) ->
      res.send html
    .catch (err) ->
      log.trace err
      res.status(500).send()

router.get '*', (req, res) ->
  log.info 'AGENT ', req.useragent.source

  # Game Subdomain - 0.0.0.0 used when testing locally
  if req.hostname isnt config.HOSTNAME and req.hostname isnt '0.0.0.0'
    gameKey = req.hostname.split('.')[0]

    return renderGamePage gameKey, req.clay.me
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err
        renderHomePage(req.clay.me)
        .then (html) ->
          res.send html
        .catch (err) ->
          log.trace err
          res.status(500).send()

  renderHomePage(req.clay.me)
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err
    res.status(500).send()

# Cache rendering
renderHomePage = do ->
  page =
    inlineSource: config.ENV is config.ENVS.PROD
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

  rendered = Promise.promisify(dust.render, dust) 'index', page

  (me) ->
    rendered.then (html) ->
      html.replace 'REPLACE_WITH_ME', JSON.stringify me

renderGamePage = (gameKey, me) ->

  gameUrl = apiRequestUrl "games/findOne?key=#{gameKey}"

  log.info 'GET', gameUrl
  Promise.promisify(request.get, request) gameUrl
  .timeout API_REQUEST_TIMEOUT_MS
  .spread (res, body) ->
    game = JSON.parse body
    if _.isEmpty game
      throw new Error 'Game not found: ' + gameKey

    page =
      inlineSource: config.ENV is config.ENVS.PROD
      title: "#{game.name}"
      description: "Play #{game.name}; #{game.description}"
      keywords: "#{game.name}, mobile games,  free mobile games"
      name: "#{game.name} - Clay.io"

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

    Promise.promisify(dust.render, dust) 'index', page

module.exports = app
