#!/usr/bin/env coffee
log = require 'loglevel'

app = require '../server'

app.listen process.env.PORT or 3000, ->
  log.info 'Listening on port %d', process.env.PORT or 3000
