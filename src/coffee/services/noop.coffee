log = require 'loglevel'
_ = require 'lodash'

class NoopService
  noop: -> null



module.exports = new NoopService()
