_ = require 'lodash'
kik = require 'kik'
log = require 'clay-loglevel'

User = require '../models/user'
Game = require '../models/game'


#
# SDK listener for Clay.client() calls
#

module.exports = class SDKDir

  config: ($el, isInit, ctx) ->

    # run once
    if isInit
      return

    window.addEventListener 'message', onMessage

    ctx.onunload = ->
      window.removeEventListener 'message', onMessage

###
# Messages follow the json-rpc 2.0 spec: http://www.jsonrpc.org/specification
# _clay is added to denote a clay message

# Without an `id` this is a notification
@typedef {Object} RPCRequest
@property {Integer} [id]
@property {String} method
@property {Array<*>} params
@property {Boolean} _clay - Must be true
@property {String} jsonrpc - Must be '2.0'

@typedef {Object} RPCResponse
@property {Integer} [id]
@property {*} result
@property {RPCError} error

@typedef {Object} RPCError
@property {Integer} code
@property {String} message


# We support EventListeners via ClayEventListener objects in params
# If a message is recived with this object, we will emit json-rpc nofications,
# using ClayEventListener.#{id} as the method name

@typedef {Object} ClayEventListener
@property {Integer} _ClayEventListener - Id for callback fn


# Example
# client.postMessage - RPCRequest
#   id: 1
#   method: 'kik.send'
#   params: [
#     {text: 'hi'}
#     {_ClayEventListener: 1}
#   ]
#
#  client.emit - RPCResponse
#    id: 1
#    result: 'abc'
#
#  And if the second param is called as a function like so:
#  kik.send(opt, cb) -> cb(12, '34')
#
#  client.emit - RPCRequest
#    method: 'ClayEventListener.1'
#    params: [12, '34']

###

###
# Emits RPCResponse object to event source
@param {RPCRequest} e
###
onMessage = (e) ->

  try
    data = JSON.parse e.data

    unless data._clay and data.jsonrpc is '2.0'
      throw new Error 'Not a Clay message'

    method = data.method
    params = data.params or []
    id = data.id

    log.info '[SDK] Message:', data

  catch err
    # Error parsing, ignore (other apps may post messages)
    return

  fn = methodToFn method

  context =
    gameId: data.gameId
    acessToken: data.accessToken

  # TODO: (Zoli) Don't use 'this' context for metadata figure something else out
  evalFn e.source, fn, params, context
  .then (result) ->
    message = _.defaults {id}, result: result
    e.source.postMessage JSON.stringify(message), '*'
  .catch (err) ->

    # json-rpc 2.0 error codes
    code = switch err.message
      when 'Method not found'
        -32601
      else
        -1

    message = _.defaults {id}, error: {code, message: err.message}

    e.source.postMessage JSON.stringify(message), '*'

###
# Fetch function based on string identifier

@param {String} method
@returns {Function}
###
methodToFn = (method) ->
  switch method
    when 'ping'
      -> 'pong'

    when 'auth.getStatus'
      authGetStatus

    when 'share.any'
      shareAny

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

###
# Apply params to function, populating event listeners

@param {Window} source
@param {Function} fn
@param {Array} params
@returns {Promise<*>}
###
evalFn = (source, fn, params, context) ->
  new Promise (resolve, reject) ->

    # Bind all callback functions
    boundParams = _.map params, (param) ->
      if param?._ClayEventListener
      then (args...) ->
        id = param._ClayEventListener
        emitEvent source, "ClayEventListener.#{id}", args
      else param
    resolve fn.apply context, boundParams

###
@param {Window} source
@param {String} method
@param {Array} params
###
emitEvent = (source, method, params) ->
  message = {method, params}
  source.postMessage JSON.stringify(message), '*'

###
@typedef AuthStatus
@property {String} accessToken
###

###
@returns {Promise<AuthStatus>}
###
authGetStatus = ->
  User.getMe().then (user) ->
    accessToken: String user.id

# coffeelint: disable=missing_fat_arrows
shareAny = ({text}) ->
  gameId = @gameId

  tweet = (text) ->
    text = encodeURIComponent text.substr 0, 140
    window.open "https://twitter.com/intent/tweet?text=#{text}"

  Game.get(gameId)
  .then (game) ->
    unless game
      throw new Error 'gameId invalid'

    if Boolean kik.send
      kik.send
        title: "#{game.name}"
        text: text
        data:
          gameKey: "#{game.key}"
    else
      tweet(text)
  .catch ->
    tweet(text)
# coffeelint: enable=missing_fat_arrows
