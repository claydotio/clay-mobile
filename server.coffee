express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
request = require 'request'
url = require 'url'
_ = require 'lodash'
Promise = require 'bluebird'
useragent = require 'express-useragent'
compress = require 'compression'
session = require 'express-session'
log = require 'loglevel'

config = require './src/coffee/config'
serverConfig = require './server_config'

router = express.Router()
log.enableAll()

# Dust templates
# Don't compact whitespace, because it breaks the javascript partial
dust.optimizers.format = (ctx, node) -> node

indexTpl = dust.compile fs.readFileSync('index.dust', 'utf-8'), 'index'
distJs = dust.compile fs.readFileSync('dist/js/bundle.js', 'utf-8'), 'distjs'
distCss = dust.compile fs.readFileSync('dist/css/bundle.css', 'utf-8'),
  'distcss'

dust.loadSource distJs
dust.loadSource distCss
dust.loadSource indexTpl


# Middlewares
app = express()

app.use compress()
app.use useragent.express()
if config.ENV is config.ENVS.PROD
then app.use express['static'](__dirname + '/dist')
else app.use express['static'](__dirname + '/build')

# After checking static files
app.use router

app.listen process.env.PORT or 3000
log.info 'Listening on port', process.env.PORT or 3000


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

  renderGamePage gameKey
  .then (html) ->
    res.send html
  .catch (err) ->
    log.trace err

    renderHomePage()
    .then (html) ->
      res.send html
    .catch (err) ->
      log.trace err
      res.status(500).send()

router.get '*', (req, res) ->
  log.info 'AGENT ', req.useragent.source

  # Game Subdomain
  if req.hostname isnt config.HOSTNAME
    gameKey = req.hostname.split('.')[0]

    return renderGamePage gameKey
      .then (html) ->
        res.send html
      .catch (err) ->
        log.trace err
        renderHomePage()
        .then (html) ->
          res.send html
        .catch (err) ->
          log.trace err
          res.status(500).send()

  renderHomePage()
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

  rendered = Promise.promisify(dust.render, dust) 'index', page

  ->
    rendered

renderGamePage = (gameKey) ->
  apiPath = url.parse config.API_PATH + '/'

  unless apiPath.hostname
    apiPath.hostname = config.HOSTNAME

  unless apiPath.protocol
    apiPath.protocol = 'http'

  gameUrl = url.resolve url.format(apiPath), "games/findOne?key=#{gameKey}"

  log.info 'GET', url.format(gameUrl)
  Promise.promisify(request.get, request) url.format(gameUrl)
  .then (response) ->
    game = JSON.parse response[0].body
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

    Promise.promisify(dust.render, dust) 'index', page
