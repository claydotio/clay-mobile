_ = require 'lodash'
Q = require 'q'
should = require('clay-chai').should()

SDKDir = require 'directives/sdk'
User = require 'models/user'

eventListeners = {}

emit = (message) ->
  message = _.defaults message, {_clay: true, jsonrpc: '2.0'}

  Q.Promise (resolve, reject) ->
    event = document.createEvent 'Event'
    event.initEvent 'message', false, false
    event.data = JSON.stringify message
    event.source = {
      postMessage: (res, target) ->
        target.should.be '*'
        parsed = JSON.parse res

        if parsed.id
          if parsed.error
            return reject parsed

          resolve parsed
        else
          method = parsed.method
          listenerId = method.match(/ClayEventListener\.(\d+)/)[1]
          eventListeners[listenerId].call null, parsed
    }

    window.dispatchEvent event


describe 'SDKDir', ->

  before ->

    # Stub user dependency
    User.setMe
      id: 1

    # Stub kik dependency
    SDKDir.__set__ 'kik',
      send: (cb) ->
        cb 'sent!'
      browser:
        setOrientationLock: -> null
      metrics:
        enableGoogleAnalytics: -> null

    directive = new SDKDir()
    $el = document.createElement 'div'
    ctx = {onunload: _.noop}
    directive.config $el, false, ctx

  it 'pong()', ->
    emit {method: 'ping', id: 1}
    .then (res) ->
      res.id.should.be 1
      res.result.should.be 'pong'

  it 'auth.getStatus()', ->
    emit {method: 'auth.getStatus', id: 1}
    .then (res) ->
      res.result.accessToken.should.be '1'

  describe 'kik methods', ->
    it 'kik.isEnabled', ->
      emit {method: 'kik.isEnabled', id: 1}
      .then (res) ->
        res.result.should.be true

    it 'kik.send', (done) ->
      eventListeners[1] = (res) ->
        res.params[0].should.be 'sent!'
        done()
      emit {method: 'kik.send', params: [{_ClayEventListener: 1}], id: 1}

    it 'kik.browser.setOrientationLock', ->
      emit {method: 'kik.browser.setOrientationLock', id: 1}
        .then (res) ->
          should.not.exist res.result

    it 'kik.metrics.enableGoogleAnalytics', ->
      emit {method: 'kik.metrics.enableGoogleAnalytics', id: 1}
        .then (res) ->
          should.not.exist res.result

  describe 'unsupported methods', ->
    it 'fails', ->
      emit {method: 'NONE', id: 1}
      .then (res) ->
        throw new Error 'expected error'
      , (res) ->
        res.error.code.should.be -32601
