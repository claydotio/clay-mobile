UrlService = require './url'

IS_FRAMED = window.self isnt window.top

pendingMessages = {}

postMessage = do ->
  messageId = 1

  (message) ->
    deferred = Promise.defer()

    try
      message.id = messageId
      message._clay = true
      message.jsonrpc = '2.0'

      pendingMessages[message.id] = deferred

      messageId += 1

      # It's not possible to tell who the parent is here
      # The client has to ping the parent and get a response to verify
      window.parent.postMessage JSON.stringify(message), '*'

    catch err
      deferred.reject err

    return Promise.race [
      deferred.promise
      new Promise (resolve, reject) ->
        setTimeout( ->
          reject 'Timeout waiting for response from parent frame'
        , 1000 )
    ]

onMessage = (e) ->
  unless isValidOrigin e.origin
    throw new Error "Invalid origin #{e.origin}"

  message = JSON.parse e.data

  unless message.id
    return

  pendingMessages[message.id].resolve message.result



isValidOrigin = (origin) ->
  regex = new RegExp '^file://' # FIXME: need something more secure
  return regex.test origin


class Native
  constructor: ->
    @isInitialized =  false

  _init: =>
    if @isInitialized
      return
    @isInitialized = true
    window.addEventListener 'message', onMessage

  # This is used to verify that the parent is cordova
  # If it's not, the postMessage promise will fail because of onMessage check
  validateParent: =>

    unless IS_FRAMED
      return Promise.resolve false

    unless @isInitialized
      @_init()

    new Promise (resolve, reject) ->
      postMessage
        method: 'ping'
      .then ->
        resolve true
      .catch (err) ->
        resolve false

  client: (message) =>
    unless IS_FRAMED
      return Promise.resolve null # soft fail

    @validateParent().then ->
      postMessage message

  shareMarketplace: =>
    # TODO: (Austin) change to google play link
    message = 'Come play the best gamsdfes on Kik with me! http://clay.io'
    subject = 'Free Games!'
    @client method: 'share.all', params: [message, subject]

  shareGame: (game) =>
    console.log game
    message = "Come play #{game.name} with me!
              #{UrlService.getMarketplaceGame({game})}"
    subject = "Play #{game.name}!"
    @client method: 'share.all', params: [message, subject]

module.exports = new Native()
