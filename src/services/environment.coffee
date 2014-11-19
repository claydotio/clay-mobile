kik = require 'kik'

NativeService = require './native'

class Environment
  constructor: -> null

  getPlatform: ->
    Promise.all [
      Promise.resolve kik?.send
      NativeService.validateParent()
    ]
    .then ([isKik, isAndroidApp]) ->
      if isKik then 'kik'
      else if isAndroidApp then 'androidApp'
      else 'browser'

module.exports = new Environment()
