_ = require 'lodash'
should = require('clay-chai').should()
rewire = require 'rewire'

SDKDir = rewire 'directives/sdk'
User = require 'models/user'

eventListeners = {}

emit = (message) ->
  message = _.defaults message, {_clay: true, jsonrpc: '2.0'}

  new Promise (resolve, reject) ->
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

  describe 'share.any()', ->
    it 'shares via kik', ->
      SDKDir.__set__ 'kik.send', (params) ->
        return params

      emit {method: 'share.any', id: 1, params: [{text: 'HELLO'}], gameId: 1}
      .then (data) ->
        data.result.title.should.be 'Prism'
        data.result.text.should.be 'HELLO'

    it 'shares via twitter if kik unavailable', (done) ->
      SDKDir.__set__ 'kik.send', null

      SDKDir.__set__ 'window.open', (url) ->
        url.should.be 'https://twitter.com/intent/tweet?text=HELLO'
        done()

      emit {method: 'share.any', id: 1, params: [{text: 'HELLO'}], gameId: 1}
      .catch done

  describe 'kik methods', ->
    before ->
      SDKDir.__set__ 'kik',
        send: (params) ->
          return params
        browser:
          setOrientationLock: -> null
        metrics:
          enableGoogleAnalytics: -> null

    it 'kik.isEnabled', ->
      emit {method: 'kik.isEnabled', id: 1}
      .then (res) ->
        res.result.should.be true

    it 'kik.send', ->
      emit {method: 'kik.send', params: [{title: 'abc', text: 'def'}], id: 1}
      .then (data) ->
        data.result.title.should.be 'abc'
        data.result.text.should.be 'def'

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
