should = require('clay-chai').should()
rewire = require 'rewire'

EnvironmentService = rewire 'services/environment'

describe 'EnvironmentService', ->

  describe 'isAndroid', ->
    it 'true', ->
      overrides =
        navigator:
          appVersion: '5.0 (Linux; Android 4.2.1; en-us; Nexus 4 ' +
                      'Build/JOP40D) AppleWebKit/535.19 (KHTML, like Gecko) ' +
                      'Chrome/18.0.1025.166 Mobile Safari/535.19'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isAndroid().should.be.true

    it 'false', ->
      overrides =
        navigator:
          appVersion: 'not @ndroid'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isAndroid().should.be.false

  describe 'isClayApp', ->
    it 'true', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (Linux; Android 4.4.0; en-us; ' +
                     'Nexus 4 Build/JOP40D) AppleWebKit/535.19 ' +
                     '(KHTML, like Gecko) Clay/0.0.4' +
                     'Chrome/18.0.1025.166 Mobile Safari/535.19'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isClayApp().should.be.true

    it 'false', ->
      overrides =
        navigator:
          userAgent: 'not cl@yapp'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isClayApp().should.be.false

  describe 'isKikEnabled', ->
    it 'true', ->
      overrides =
        kik:
          enabled: true

      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isKikEnabled().should.be true

    it 'false', ->
      overrides =
        kik:
          enabled: false

      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isKikEnabled().should.be false

  describe 'isFirefoxOS', ->
    it 'is true for FFOS UA', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (Mobile; rv:14.0) Gecko/14.0 Firefox/14.0'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isFirefoxOS().should.be true

    it 'is false for Nexus 5 UA', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 5 Build/KOT49H)
                      AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.99
                      Mobile Safari/537.36'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isFirefoxOS().should.be false

    it 'is false for FF on Android Mobile UA', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (Android; Mobile; rv:14.0)
                     Gecko/14.0 Firefox/14.0'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isFirefoxOS().should.be false

    it 'is false for FF on Android Tablet UA', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (Android; Tablet; rv:14.0)
                      Gecko/14.0 Firefox/14.0'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isFirefoxOS().should.be false

    it 'is false for FF on iOS UA (does not exist, but could)', ->
      overrides =
        navigator:
          userAgent: 'Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X)
                      AppleWebKit/537.51.1 (KHTML, like Gecko)
                      Version/7.0 Mobile/11A465 Safari/9537.53'
      EnvironmentService.__with__(overrides) ->
        EnvironmentService.isFirefoxOS().should.be false
