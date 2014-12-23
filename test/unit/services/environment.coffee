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
