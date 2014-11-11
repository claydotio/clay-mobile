#!/usr/bin/env coffee
log = require 'loglevel'

app = require '../server'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
config = require '../src/config'

webpackDevPort = process.env.WEBPACK_DEV_PORT or 3004
webpackDevHostname = config.WEBPACK_DEV_HOSTNAME

isMockingApi = process.env.MOCK

app.all '/*', (req, res, next) ->
  res.header(
    'Access-Control-Allow-Origin', "//#{webpackDevHostname}:#{webpackDevPort}"
  )
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  next()

app.listen process.env.PORT or 3000, ->
  log.info 'Listening on port %d', process.env.PORT or 3000


entries = [
  "webpack-dev-server/client?http://#{webpackDevHostname}:#{webpackDevPort}"
  'webpack/hot/dev-server'
  './src/root'
]
# Order matters because mock overrides window.XMLHttpRequest
if isMockingApi
  entries = ['./src/mock'].concat entries

new WebpackDevServer webpack({
  entry: entries
  output:
    path: __dirname,
    filename: 'bundle.js',
    publicPath: "//#{webpackDevHostname}:#{webpackDevPort}/js/"
  module:
    postLoaders: [
      { test: /\.coffee$/, loader: 'transform/cacheable?envify' }
    ]
    loaders: [
      { test: /\.coffee$/, loader: 'coffee' }
      { test: /\.json$/, loader: 'json' }
      { test: /\.styl$/, loader: 'style/useable!css!stylus?paths=components/' }
    ]
  plugins: [
    new webpack.HotModuleReplacementPlugin()
  ]
  externals:
    kik: 'kik'
  resolve:
    extensions: ['.coffee', '.js', '.json', '']
}),
  publicPath: "//#{webpackDevHostname}:#{webpackDevPort}/js/"
  hot: true
.listen webpackDevPort, (err) ->
  if err
    log.trace err
  log.info 'Webpack listening on port %d', webpackDevPort
