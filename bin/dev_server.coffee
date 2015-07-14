#!/usr/bin/env coffee
log = require 'loglevel'

app = require '../server'
webpack = require 'webpack'
WebpackDevServer = require 'webpack-dev-server'
config = require '../src/config'

webpackDevPort = config.WEBPACK_DEV_PORT
webpackDevHostname = config.WEBPACK_DEV_HOSTNAME
isMockingApi = config.MOCK

app.all '/*', (req, res, next) ->
  res.header(
    'Access-Control-Allow-Origin', "//#{webpackDevHostname}:#{webpackDevPort}"
  )
  res.header 'Access-Control-Allow-Headers', 'X-Requested-With'
  next()

app.listen config.PORT, ->
  log.info 'Listening on port %d', config.PORT


entries = [
  "webpack-dev-server/client?http://#{webpackDevHostname}:#{webpackDevPort}"
  'webpack/hot/dev-server'
]
# Order matters because mock overrides window.XMLHttpRequest
if isMockingApi
  entries = entries.concat ['./src/mock']
entries = entries.concat ['./src/root']

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
      { test: /\.styl$/, loader: 'style/useable!css!stylus?paths=node_modules' }
    ]
  plugins: [
    new webpack.HotModuleReplacementPlugin()
    new webpack.ResolverPlugin \
      new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin \
        'bower.json', ['main']
  ]
  externals:
    kik: 'kik'
  resolve:
    extensions: ['.coffee', '.js', '.json', '']
    # browser-builtins is for modules requesting native node modules
    modulesDirectories: ['web_modules', 'node_modules', './src',
    'bower_components', './node_modules/browser-builtins/builtin']
    root: [__dirname + '/bower_components']
}),
  publicPath: "//#{webpackDevHostname}:#{webpackDevPort}/js/"
  hot: true
.listen webpackDevPort, (err) ->
  if err
    log.trace err
  log.info 'Webpack listening on port %d', webpackDevPort
