_ = require 'lodash'
kik = require 'kik'
log = require 'loglevel'
Q = require 'q'

User = require '../models/user'

module.exports = class SDKDir

  config: ($el, isInit, ctx) ->

    # run once
    if isInit
      return

    window.addEventListener 'message', onMessage

    ctx.onunload = ->
      window.removeEventListener 'message', onMessage


onMessage = (e) ->

  # Unable to find the source of this event,
  # may be the browser or chrome extension
  if e.data is 'process-tick'
    return

  try
    data = if _.isObject e.data then e.data else JSON.parse e.data
    method = data.method
    params = data.params or []
    id = data.id

    # Ignore messages without an id (from other apps)
    unless id
      return

    log.info '[SDK] Message:', data

  catch err
    log.trace err
    return

  fn = methodToFn method

  evalFn e.source, fn, params
  .then (result) ->
    message = _.defaults {id}, result: result
    e.source.postMessage JSON.stringify(message), '*'
  .catch (err) ->
    code = switch err.message
      when 'Method not found'
        -32601
      else
        -1

    message = _.defaults {id}, error: {code, message: err.message}

    e.source.postMessage JSON.stringify(message), '*'

methodToFn = (method) ->
  switch method
    when 'ping'
      -> 'pong'

    when 'auth.getStatus'
      authGetStatus

    # Kik methods
    when 'kik.isEnabled'
      # Kik.send is checked as per documetation
      -> Boolean kik.send

    when 'kik.send'
      _.bind kik.send, kik

    when 'kik.browser.setOrientationLock'
      _.bind kik.browser.setOrientationLock, kik.browser

    when 'kik.metrics.enableGoogleAnalytics'
      _.bind kik.metrics.enableGoogleAnalytics, kik.metrics

    else -> throw new Error 'Method not found'

evalFn = (source, fn, params) ->
  Q.Promise (resolve, reject) ->

    # Bind all callback functions
    boundParams = _.map params, (param) ->
      if param?._ClayEventListener
      then (args...) ->
        id = param._ClayEventListener
        emitEvent source, "ClayEventListener.#{id}", args
      else param
    resolve fn.apply null, boundParams

emitEvent = (source, method, params) ->
  message = {method, params}
  source.postMessage JSON.stringify(message), '*'

authGetStatus = ->
  User.getMe().then (user) ->
    accessToken: user.id
