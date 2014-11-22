UrlService = require './url'

# FIXME: this entire file should be wiped out for impact hammer
# + use Clay.client method: 'share.all', ... structure

IS_FRAMED = window.self isnt window.top

class Native
  constructor: ->
    @isInitialized =  false
    @pendingMessages = {}
    @messageId = 1

  _init: =>
    if @isInitialized
      return
    @isInitialized = true
    window.addEventListener 'message', @onMessage

  onMessage: (e) =>
    unless @isValidOrigin e.origin
      throw new Error "Invalid origin #{e.origin}"

    message = JSON.parse e.data

    unless message.id
      return

    @pendingMessages[message.id].resolve message.result

  isValidOrigin: (origin) ->
    # not super secure, but I haven't thought of a way to improve it
    # cordova has its origin set as file://
    # If some other native app framed us, technically they'd just receive the
    # messages we send since verifyParent() would pass
    regex = new RegExp '^file://$'
    return regex.test origin


  postMessage: (message) =>
    deferred = -> new Promise (@resolve, @reject) => null

    try
      message.id = @messageId
      message._clay = true
      message.jsonrpc = '2.0'

      @pendingMessages[message.id] = deferred

      @messageId += 1

      # It's not possible to tell who the parent is here
      # The client has to ping the parent and get a response to verify
      window.parent.postMessage JSON.stringify(message), '*'

    catch err
      reject err

    return Promise.race [
      deferred
      new Promise (resolve, reject) ->
        setTimeout( ->
          reject 'Timeout waiting for response from parent frame'
        , 1000 )
    ]

  # This is used to verify that the parent is cordova
  # If it's not, the postMessage promise will fail because of onMessage check
  validateParent: =>
    unless IS_FRAMED
      return Promise.resolve false

    unless @isInitialized
      @_init()

    new Promise (resolve, reject) =>
      @postMessage
        method: 'ping'
      .then ->
        resolve true
      .catch (err) ->
        resolve false

  client: (message) =>
    unless IS_FRAMED
      return Promise.resolve null # soft fail
    @validateParent().then =>
      @postMessage message

  shareMarketplace: =>
    message = 'Play some fun games with me! http://clay.io'
    subject = 'Free Games!'
    @client method: 'share.all', params: [message, subject]

  shareGame: (game) =>
    message = "Come play #{game.name} with me!
              #{UrlService.getMarketplaceGame({game})}"
    subject = "Play #{game.name}!"
    @client method: 'share.all', params: [message, subject]

module.exports = new Native()
