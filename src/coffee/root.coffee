z = require 'zorium'
log = require 'loglevel'

HomePage = new (require './pages/home')()

log.enableAll()

z.route.mode = 'hash'
z.route document.getElementById('app'), '/',
  '/': HomePage

log.info 'App Ready'
