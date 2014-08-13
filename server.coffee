'use strict'

# Static assets
express = require 'express'
app = express()

router = express.Router()

if process.env.NODE_ENV is 'production'
  app.use express['static'](__dirname + '/dist')
else
  app.use express['static'](__dirname + '/build')

router.get /^(?!([^.]\w+$))/, (req, res) ->
  res.sendfile './build/index.html'

app.use router

app.listen process.env.PORT or 3000

console.log 'Listening on port', process.env.PORT or 3000

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
