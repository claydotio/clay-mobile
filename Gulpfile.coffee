_ = require 'lodash'
gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
nodemon = require 'gulp-nodemon'
rename = require 'gulp-rename'
browserify = require 'browserify'
clean = require 'gulp-clean'
sourcemaps = require 'gulp-sourcemaps'
source = require 'vinyl-source-stream'
runSequence = require 'gulp-run-sequence'
stylus = require 'gulp-stylus'
coffeelint = require 'gulp-coffeelint'
glob = require 'glob'
karma = require('karma').server
minifyCss = require 'gulp-minify-css'
rewireify = require 'rewireify'

karmaConf = require './karma.defaults'

# Modify NODE_PATH for test require's
process.env.NODE_PATH += ':' + __dirname + '/src/coffee'

outFiles =
  scripts: 'bundle.js'
  styles: 'bundle.css'

paths =
  static: './src/*.*'
  scripts: './src/coffee/**/*.coffee'
  styles: './src/stylus/**/*.styl'

  tests: './test/**/*.coffee'
  root: './src/coffee/root.coffee'
  mock: './src/coffee/mock.coffee'
  baseStyle: './src/stylus/base.styl'
  dist: './dist/'
  build: './build/'

isMockingApi = process.env.MOCK

# start the dev server, and auto-update
gulp.task 'dev', ['assets:dev', 'test:phantom', 'watch'], ->
  gulp.start 'server'

# compile sources: src/* -> build/*
gulp.task 'assets:dev', [
  'scripts:dev'
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
gulp.task 'test', ['scripts:dev', 'scripts:test'], (cb) ->
  karma.start _.defaults(singleRun: true, karmaConf), cb

gulp.task 'test:phantom', ['scripts:dev', 'scripts:test'], (cb) ->
  karma.start _.defaults({
    singleRun: true,
    browsers: ['PhantomJS']
  }, karmaConf), cb

gulp.task 'scripts:test', ['lint:tests'], ->
  testFiles = glob.sync('./test/**/*.coffee')
  browserify
    entries: testFiles
    extensions: ['.coffee']
  .transform {global: true}, 'rewireify'
  .bundle(debug: true)
  .on 'error', errorHandler
  .pipe source outFiles.scripts
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
  nodemon {script: 'server.coffee', ext: 'null', ignore: ['**/*.*']}


gulp.task 'watch', ->
  gulp.watch paths.scripts, ['scripts:dev', 'test:phantom']
  gulp.watch paths.styles, ['styles:dev']
  gulp.watch paths.tests, ['test:phantom']

# run coffee-lint
gulp.task 'lint:scripts', ->
  gulp.src paths.scripts
    .pipe coffeelint()
    .pipe coffeelint.reporter()

#
# Dev compilation
#

errorHandler = ->
  gutil.log.apply null, arguments
  @emit 'end'

# init.coffee --> build/js/bundle.js
gulp.task 'scripts:dev', ['lint:scripts'], ->
  entries = [paths.root]

  # Order matters because mock overrides window.XMLHttpRequest
  if isMockingApi
    entries = [paths.mock].concat entries

  browserify
    entries: entries
    extensions: ['.coffee']
  .transform {global: true}, 'rewireify'
  .bundle(debug: true)
  .on 'error', errorHandler
  .pipe source outFiles.scripts
  .pipe gulp.dest paths.build + '/js/'

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
gulp.task 'scripts:prod', ['lint:scripts'], ->
  browserify
    entries: paths.root
    extensions: ['.coffee']
  .transform {global: true}, 'uglifyify'
  .bundle()
  .pipe source outFiles.scripts
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
