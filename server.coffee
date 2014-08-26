'use strict'

# Static assets
express = require 'express'
app = express()

router = express.Router()

indexFile = './build/index.html'
if process.env.NODE_ENV is 'production'
  app.use express['static'](__dirname + '/dist')
  indexFile = './dist/index.html'
else
  app.use express['static'](__dirname + '/build')

router.get /^(?!([^.]\w+$))/, (req, res) ->
  res.sendfile indexFile

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
