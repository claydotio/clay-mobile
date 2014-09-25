_ = require 'lodash'
Q = require 'q'
should = require('clay-chai').should()

SDKDir = require 'directives/sdk'

SDKDir.__set__('kik', {
  message: 'TEST MESSAGE'
  picker:
    reply: -> null
  linkData: 'TEST DATA'
  browser:
    background: false
    getOrientationLock: -> 'NOT FROM CALLBACK'
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
})


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
    directive = new SDKDir()
    $el = document.createElement 'div'
    ctx = {onunload: _.noop}
    directive.config $el, false, ctx

  it 'pong()', ->
    emit {method: 'ping', _id: 1}
    .then (res) ->
      res._id.should.be 1

  it 'auth.getStatus()', ->
    emit {method: 'auth.getStatus'}
    .then (res) ->
      res.result.accessToken.should.be 1

  describe 'custom kik methods', ->

    it 'kik.getMessage()', ->
      emit {method: 'kik.getMessage'}
      .then (res) ->
        res.result.should.be 'TEST MESSAGE'

    it 'kik.isInPicker()', ->
      emit {method: 'kik.isInPicker'}
      .then (res) ->
        res.result.should.be true

    it 'kik.getLinkData()', ->
      emit {method: 'kik.getLinkData'}
      .then (res) ->
        res.result.should.be 'TEST DATA'

    it 'kik.isBrowserBackground()', ->
      emit {method: 'kik.isBrowserBackground'}
      .then (res) ->
        res.result.should.be false

    it 'kik.getPlatformOS()', ->
      emit {method: 'kik.getPlatformOS'}
      .then (res) ->
        res.result.should.be 'TEST OS'

    it 'kik.getPlatformBrowser()', ->
      emit {method: 'kik.getPlatformBrowser'}
      .then (res) ->
        res.result.should.be 'TEST BROWSER'

    it 'kik.getPlatformEngine()', ->
      emit {method: 'kik.getPlatformEngine'}
      .then (res) ->
        res.result.should.be 'TEST ENGINE'

    it 'kik.unknown1()', ->
      emit {method: 'kik.unknown1', params: ['p']}
      .then (res) ->
        res.result.should.be ['p', 'ONE']

    it 'kik.unknown2.unknown3()', ->
      emit {method: 'kik.unknown2.unknown3', params: ['p']}
      .then (res) ->
        res.result.should.be ['p', 'THREE']

    it 'kik.deep.deep.deep.deep()', ->
      emit {method: 'kik.deep.deep.deep.deep', params: ['p']}
      .then (res) ->
        res.result.should.be ['p', 'DEEP']

    it 'returns array if callback recieves multiple parameters', ->
      emit {method: 'kik.mulipleParams'}
      .then (res) ->
        res.result.should.be [1, 2, 3]

  describe 'kik methods with no callback', ->
    it 'kik.hasPermission', ->
      emit {method: 'kik.hasPermission'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.send', ->
      emit {method: 'kik.send'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.open', ->
      emit {method: 'kik.open'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.metrics.enableGoogleAnalytics', ->
      emit {method: 'kik.metrics.enableGoogleAnalytics'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.browser.getOrientationLock', ->
      emit {method: 'kik.browser.getOrientationLock'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.show', ->
      emit {method: 'kik.formHelpers.show'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.hide', ->
      emit {method: 'kik.formHelpers.hide'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.formHelpers.isEnabled', ->
      emit {method: 'kik.formHelpers.isEnabled'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'

    it 'kik.trigger', ->
      emit {method: 'kik.trigger'}
      .then (res) ->
        res.result.should.be 'NOT FROM CALLBACK'


  describe 'unsupported methods', ->
    it 'kik.photo.getFromCamera', ->
      emit {method: 'kik.photo.getFromCamera'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.photo.getFromGallery', ->
      emit {method: 'kik.photo.getFromGallery'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.browser.on', ->
      emit {method: 'kik.browser.on'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.on', ->
      emit {method: 'kik.on'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.off', ->
      emit {method: 'kik.off'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'

    it 'kik.once', ->
      emit {method: 'kik.once'}
      .then (res) ->
        res.error.should.be 'METHOD NOT SUPPORTED'
