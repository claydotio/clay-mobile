_ = require 'lodash'
Q = require 'q'
should = require('clay-chai').should()

SDKDir = require 'directives/sdk'
User = require 'models/user'

emit = (message) ->
  Q.Promise (resolve, reject) ->
    event = document.createEvent 'Event'
    event.initEvent 'message', false, false
    event.data = JSON.stringify message
    event.source = {
      postMessage: (res, target) ->
        target.should.be '*'
        resolve JSON.parse res
    }

    window.dispatchEvent event


describe 'SDKDir', ->

  before ->

    # Stub user dependency
    User.setMe
      id: 1

    # Stub kik dependency
    SDKDir.__set__ 'kik',
      message: 'TEST MESSAGE'
      picker:
        reply: -> null
      linkData: 'TEST DATA'
      browser:
        background: false
        getOrientationLock: -> 'NOT FROM CALLBACK'
        setOrientationLock: -> 'NOT FROM CALLBACK'
      utils:
        platform:
          os: 'TEST OS'
          browser: 'TEST BROWSER'
          engine: 'TEST ENGINE'

      unknown1: (s, cb) -> cb [s, 'ONE']
      unknown2:
        unknown3: (s, cb) -> cb [s, 'THREE']
      deep:
        deep:
          deep:
            deep: (s, cb) -> cb [s, 'DEEP']
      mulipleParams: (cb) -> cb 1, 2, 3

      hasPermission: -> 'NOT FROM CALLBACK'
      send: -> 'NOT FROM CALLBACK'
      open: -> 'NOT FROM CALLBACK'
      metrics:
        enableGoogleAnalytics: -> 'NOT FROM CALLBACK'

      formHelpers:
        show: -> 'NOT FROM CALLBACK'
        hide: -> 'NOT FROM CALLBACK'
        isEnabled: -> 'NOT FROM CALLBACK'
      trigger: -> 'NOT FROM CALLBACK'

    directive = new SDKDir()
    $el = document.createElement 'div'
    ctx = {onunload: _.noop}
    directive.config $el, false, ctx

  it 'pong()', ->
    emit {method: 'ping', id: 1}
    .then (res) ->
      res.id.should.be 1

  it 'auth.getStatus()', ->
    emit {method: 'auth.getStatus', id: 1}
    .then (res) ->
      res.result.accessToken.should.be 1

  describe 'custom kik methods', ->

    it 'kik.getMessage()', ->
      emit {method: 'kik.getMessage', id: 1}
      .then (res) ->
        res.result.should.be 'TEST MESSAGE'

    it 'kik.isInPicker()', ->
      emit {method: 'kik.isInPicker', id: 1}
      .then (res) ->
        res.result.should.be true

    it 'kik.getLinkData()', ->
      emit {method: 'kik.getLinkData', id: 1}
      .then (res) ->
        res.result.should.be 'TEST DATA'

    it 'kik.isBrowserBackground()', ->
      emit {method: 'kik.isBrowserBackground', id: 1}
      .then (res) ->
        res.result.should.be false

    it 'kik.getPlatformOS()', ->
      emit {method: 'kik.getPlatformOS', id: 1}
      .then (res) ->
        res.result.should.be 'TEST OS'

    it 'kik.getPlatformBrowser()', ->
      emit {method: 'kik.getPlatformBrowser', id: 1}
      .then (res) ->
        res.result.should.be 'TEST BROWSER'

    it 'kik.getPlatformEngine()', ->
      emit {method: 'kik.getPlatformEngine', id: 1}
      .then (res) ->
        res.result.should.be 'TEST ENGINE'

    it 'kik.unknown1()', ->
      emit {method: 'kik.unknown1', params: ['p'], id: 1}
      .then (res) ->
        res.result.should.be ['p', 'ONE']

    it 'kik.unknown2.unknown3()', ->
      emit {method: 'kik.unknown2.unknown3', params: ['p'], id: 1}
      .then (res) ->
        res.result.should.be ['p', 'THREE']

    it 'kik.deep.deep.deep.deep()', ->
      emit {method: 'kik.deep.deep.deep.deep', params: ['p'], id: 1}
      .then (res) ->
        res.result.should.be ['p', 'DEEP']

    it 'returns array if callback recieves multiple parameters', ->
      emit {method: 'kik.mulipleParams', id: 1}
      .then (res) ->
        res.result.should.be [1, 2, 3]

  describe 'kik methods with no callback', ->
    it 'kik.hasPermission', ->
      emit {method: 'kik.hasPermission', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.send', ->
      emit {method: 'kik.send', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.open', ->
      emit {method: 'kik.open', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.metrics.enableGoogleAnalytics', ->
      emit {method: 'kik.metrics.enableGoogleAnalytics', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.browser.getOrientationLock', ->
      emit {method: 'kik.browser.getOrientationLock', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.browser.setOrientationLock', ->
      emit {method: 'kik.browser.setOrientationLock', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.show', ->
      emit {method: 'kik.formHelpers.show', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.hide', ->
      emit {method: 'kik.formHelpers.hide', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.isEnabled', ->
      emit {method: 'kik.formHelpers.isEnabled', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.trigger', ->
      emit {method: 'kik.trigger', id: 1}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'


  describe 'unsupported methods', ->
    it 'kik.photo.getFromCamera', ->
      emit {method: 'kik.photo.getFromCamera', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.photo.getFromGallery', ->
      emit {method: 'kik.photo.getFromGallery', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.browser.on', ->
      emit {method: 'kik.browser.on', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.on', ->
      emit {method: 'kik.on', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.off', ->
      emit {method: 'kik.off', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.once', ->
      emit {method: 'kik.once', id: 1}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'
