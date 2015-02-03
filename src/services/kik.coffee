kik = require 'kik'
log = require 'clay-loglevel'

styleConfig = require '../stylus/vars.json'

KIK_PUSH_HANDLER_TIMEOUT = 250

class KikService
  constructor: ->
    @isFromPushPromise = null

  isFromPush: =>
    unless @isFromPushPromise
      @isFromPushPromise = new Promise (resolve, reject) ->
        if kik?.push?.handler
          kik.push.handler ->
            resolve true
          setTimeout (-> resolve false), KIK_PUSH_HANDLER_TIMEOUT
        else
          resolve false
    @isFromPushPromise

module.exports = new KikService()
