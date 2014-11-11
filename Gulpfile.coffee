_ = require 'lodash'
gulp = require 'gulp'
concat = require 'gulp-concat'
nodemon = require 'gulp-nodemon'
rename = require 'gulp-rename'
clean = require 'gulp-clean'
sourcemaps = require 'gulp-sourcemaps'
runSequence = require 'gulp-run-sequence'
stylus = require 'gulp-stylus'
coffeelint = require 'gulp-coffeelint'
karma = require('karma').server
minifyCss = require 'gulp-minify-css'
mocha = require 'gulp-mocha'
RewirePlugin = require 'rewire-webpack'
webpack = require 'gulp-webpack'
webpackSource = require 'webpack'

karmaConf = require './karma.defaults'

outFiles =
  scripts: 'bundle.js'
  styles: 'bundle.css'

paths =
  static: './src/*.*'
  scripts: ['./src/**/*.coffee', './*.coffee']
  styles: './src/stylus/**/*.styl'

  tests: './test/*/*.coffee'
  serverTests: './test/server.coffee'
  root: './src/root.coffee'
  rootTests: './test/index.coffee'
  baseStyle: './src/stylus/base.styl'
  dist: './dist/'
  build: './build/'

# start the dev server, and auto-update
gulp.task 'dev', ['assets:dev', 'watch:dev'], ->
  gulp.start 'server'

# compile sources: src/* -> build/*
gulp.task 'assets:dev', [
  'styles:dev'
  'static:dev'
]

# compile sources: src/* -> dist/*
gulp.task 'assets:prod', [
  'scripts:prod'
  'styles:prod'
  'static:prod'
]

# build for production
gulp.task 'build', (cb) ->
  runSequence 'clean:dist', 'assets:prod', cb

# tests
# process.exit is added due to gulp-mocha (test:server) hanging
gulp.task 'test', [
    'scripts:test'
    'test:server'
    'lint:tests'
    'lint:scripts'
  ], (cb) ->
  karma.start _.defaults(singleRun: true, karmaConf), process.exit

# gulp-mocha will never exit on its own.
gulp.task 'test:server', ['scripts:test'], ->
  gulp.src paths.serverTests
    .pipe mocha()

gulp.task 'test:phantom', ['scripts:test'], (cb) ->
  karma.start _.defaults({
    singleRun: true,
    browsers: ['PhantomJS']
  }, karmaConf), cb

gulp.task 'scripts:test', ->

  gulp.src paths.rootTests
  .pipe webpack
    module:
      postLoaders: [
        { test: /\.coffee$/, loader: 'transform/cacheable?envify' }
      ]
      loaders: [
        { test: /\.coffee$/, loader: 'coffee' }
        { test: /\.json$/, loader: 'json' }
        {
          test: /\.styl$/
          loader: 'style/useable!css!stylus?paths=components/'
        }
      ]
    externals:
      kik: '{}'
    plugins: [
      new RewirePlugin()
    ]
    resolve:
      extensions: ['.coffee', '.js', '.json', '']
      # browser-builtins is for modules requesting native node modules
      modulesDirectories: ['web_modules', 'node_modules', './src',
      './node_modules/browser-builtins/builtin']
  .pipe rename 'bundle.js'
  .pipe gulp.dest paths.build + '/test/'


# run coffee-lint
gulp.task 'lint:tests', ->
  gulp.src paths.tests
    .pipe coffeelint()
    .pipe coffeelint.reporter()

#
# Dev server and watcher
#

# start the dev server
gulp.task 'server', ->
  # Don't actually watch for changes, just run the server
  nodemon {script: 'bin/dev_server.coffee', ext: 'null', ignore: ['**/*.*']}

gulp.task 'watch:dev', ->
  gulp.watch paths.styles, ['styles:dev']

gulp.task 'watch:test', ->
  gulp.watch paths.tests, ['test:phantom']

# run coffee-lint
gulp.task 'lint:scripts', ->
  gulp.src paths.scripts
    .pipe coffeelint()
    .pipe coffeelint.reporter()

#
# Dev compilation
#

# css/style.css --> build/css/bundle.css
gulp.task 'styles:dev', ->
  gulp.src paths.baseStyle
    .pipe sourcemaps.init()
      .pipe stylus 'include css': true
      .pipe rename outFiles.styles
    .pipe sourcemaps.write()
    .pipe gulp.dest paths.build + '/css/'

# * --> build/*
gulp.task 'static:dev', ->
  gulp.src paths.static
    .pipe gulp.dest paths.build

#
# Production compilation
#

# rm -r dist
gulp.task 'clean:dist', ->
  gulp.src paths.dist, read: false
    .pipe clean()

# init.coffee --> dist/js/bundle.min.js
gulp.task 'scripts:prod', ->
  gulp.src paths.root
  .pipe webpack
    module:
      postLoaders: [
        { test: /\.coffee$/, loader: 'transform/cacheable?envify' }
      ]
      loaders: [
        { test: /\.coffee$/, loader: 'coffee' }
        { test: /\.json$/, loader: 'json' }
        {
          test: /\.styl$/
          loader: 'style/useable!css!stylus?paths=components/'
        }
      ]
    plugins: [
      new webpackSource.optimize.UglifyJsPlugin()
    ]
    externals:
      kik: 'kik'
    resolve:
      extensions: ['.coffee', '.js', '.json', '']
  .pipe rename 'bundle.js'
  .pipe gulp.dest paths.dist + '/js/'

# css/style.css --> dist/css/bundle.min.css
gulp.task 'styles:prod', ->
  gulp.src paths.baseStyle
    .pipe sourcemaps.init()
      .pipe stylus 'include css': true
      .pipe rename outFiles.styles
      .pipe minifyCss()
    .pipe sourcemaps.write '../maps/'
    .pipe gulp.dest paths.dist + '/css/'

# * --> dist/*
gulp.task 'static:prod', ->
  gulp.src paths.static
    .pipe gulp.dest paths.dist
