_ = require 'lodash'
log = require 'loglevel'

class NoopModel
  noop: _.noop



module.exports = new NoopModel()
