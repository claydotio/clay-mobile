_ = require 'lodash'

DEBUG_IMG = 'http://slime.clay.io/claymedia/icon128.png'

module.exports = class NoopCtrl
  getTop: (limit, skip) ->
    _.map _.range(limit), ->
      url: DEBUG_IMG
