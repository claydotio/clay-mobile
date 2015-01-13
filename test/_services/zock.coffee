log = require 'clay-loglevel'
Zock = require 'zock'

mock = new Zock().logger log.info

module.exports = mock
