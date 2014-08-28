'use strict'

# Static assets
express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
request = require 'request'
url = require 'url'
_ = require 'lodash'
Promise = require 'bluebird'
useragent = require 'express-useragent'

config = require './src/coffee/config'

app = express()
router = express.Router()

indexFile = './build/index.html'
if process.env.NODE_ENV is 'production'
  app.use express['static'](__dirname + '/dist')
  indexFile = './dist/index.html'
else
  app.use express['static'](__dirname + '/build')


indexTpl = dust.compile fs.readFileSync('index.dust', 'utf-8'), 'index'
dust.loadSource indexTpl

router.get '/game/:key', (req, res) ->
  gameKey = req.params.key
  isKik = req.useragent.isKik

  renderGamePage gameKey, isKik
  .then (html) ->
    res.send html
  .catch (err) ->
    console.error err

    renderHomePage isKik
    .then (html) ->
      res.send html
    .catch (err) ->
      console.error err
      res.status(500).send()

router.get '*', (req, res) ->
  isKik = req.useragent.isKik

  if req.hostname isnt config.HOSTNAME
    gameKey = req.hostname.split('.')[0]

    return renderGamePage gameKey, isKik
      .then (html) ->
        res.send html
      .catch (err) ->
        console.error err.stack
        renderHomePage isKik
        .then (html) ->
          res.send html
        .catch (err) ->
          console.error err
          res.status(500).send()

  renderHomePage isKik
  .then (html) ->
    res.send html
  .catch (err) ->
    console.error err
    res.status(500).send()

# Cache rendering
renderHomePage = do ->
  page =
    title: 'Clay.io - Play mobile games on your phone for free'
    description: 'Play mobile games on your phone for free.
                  We bring you the best mobile web games.'
    keywords: 'mobile games, phone games, free mobile games, mobile web games'
    name: 'Clay.io'
    icon256: 'http://cdn.wtf/d/images/icons/icon_256.png'
    icon76: 'http://cdn.wtf/d/images/icons/icon_76.png'
    icon120: 'http://cdn.wtf/d/images/icons/icon_120.png'
    icon152: 'http://cdn.wtf/d/images/icons/icon_152.png'
    icon440x280: 'http://cdn.wtf/d/images/icons/icon_440_280.png'
    url: 'http://clay.io/'
    canonical: 'http://clay.io'

  rendered = Promise.promisify(dust.render, dust) 'index', page

  renderedKik = Promise.promisify(dust.render, dust) 'index', _.defaults
    title: 'Free Games'
    , page

  return (isKik) ->
    if isKik then renderedKik else rendered

renderGamePage = (gameKey, isKik) ->
  apiPath = url.parse config.API_PATH

  unless apiPath.hostname
    apiPath.hostname = config.HOSTNAME

  unless apiPath.protocol
    apiPath.protocol = 'http'

  gameUrl = url.parse "#{url.format(apiPath)}/games/findOne?key=#{gameKey}"

  Promise.promisify(request.get, request) url.format(gameUrl)
  .then (response) ->
    game = JSON.parse response[0].body
    if _.isEmpty game
      throw new Error('Game not found')

    page =
      title: "Play #{game.name} - free mobile games - Clay.io"
      description: "Play #{game.name} on Clay.io, the best free mobile games"
      keywords: "#{game.name}, mobile games,  free mobile games"
      name: "#{game.name} - Clay.io"

      # TODO: (Zoli) This isn't good enough
      icon256: game.icon128Url
      icon76: game.icon128Url
      icon120: game.icon128Url
      icon152: game.icon128Url

      # TODO: (Zoli) this should be returned by the server
      icon440x280: "http://cdn.wtf/g/#{game.id}/meta/promo_440.png"
      url: "http://#{game.key}.clay.io"
      canonical: "http://#{game.key}.clay.io"

    if isKik
      page = _.defaults
        title: 'Free Games'
        , page

    Promise.promisify(dust.render, dust) 'index', page


app.use useragent.express()

# Detect Kik
app.use (req, res, next) ->
  isKik = /^Kik/.test req.useragent.source
  isKikBot = /KikBot/.test req.useragent.source
  isiOSWebView = req.useragent.isMac and
                 not req.useragent.isSafari and
                 req.useragent.isMobile

  req.useragent.isKik = isKik or isKikBot or isiOSWebView

  next()

app.use router

app.listen process.env.PORT or 3000

console.log 'Listening on port', process.env.PORT or 3000

unless process.env.NODE_ENV is 'production'
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
