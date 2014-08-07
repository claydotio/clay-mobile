log = require 'loglevel'
_ = require 'lodash'

class NoopService
  noop: _.noop



module.exports = new NoopService()
