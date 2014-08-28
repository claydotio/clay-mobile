'use strict'

# Static assets
express = require 'express'
dust = require 'dustjs-linkedin'
fs = require 'fs'
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

router.get '*', (req, res) ->

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

  dust.render 'index', page, (err, out) ->
    if err
      console.error err
      return res.status(500).send()

    res.send out

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
