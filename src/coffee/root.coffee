z = require 'zorium'
HomePage = new (require './pages/home')()

z.route.mode = 'hash'
z.route document.getElementById('app'), '/',
  '/': HomePage
