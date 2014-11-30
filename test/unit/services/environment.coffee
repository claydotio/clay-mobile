should = require('clay-chai').should()
rewire = require 'rewire'

EnvironmentService = rewire 'services/environment'

describe 'EnvironmentService', ->

  describe 'getPlatform', ->
    it 'kik', ->
      EnvironmentService.__set__ 'kik.enabled', true
      EnvironmentService.getPlatform().should.be 'kik'

    it 'native', ->
      EnvironmentService.__set__ 'kik.enabled', false
      EnvironmentService.__set__ 'navigator',
        userAgent: 'Mozilla/5.0 (Linux; Android 4.4.0; en-us; ' +
                   'Nexus 4 Build/JOP40D) AppleWebKit/535.19 ' +
                   '(KHTML, like Gecko) Clay/0.0.4' +
                   'Chrome/18.0.1025.166 Mobile Safari/535.19'
      EnvironmentService.getPlatform().should.be 'native'

    it 'browser', ->
      EnvironmentService.__set__ 'kik.enabled', false
      EnvironmentService.__set__ 'navigator',
        userAgent: 'Mozilla/5.0 (Linux; Android 4.4.0; en-us; ' +
                   'Nexus 4 Build/JOP40D) AppleWebKit/535.19 ' +
                   '(KHTML, like Gecko)' +
                   'Chrome/18.0.1025.166 Mobile Safari/535.19'
      EnvironmentService.getPlatform().should.be 'browser'

  describe 'getOS', ->
    it 'Android', ->
      EnvironmentService.__set__ 'navigator',
        appVersion: '5.0 (Linux; Android 4.2.1; en-us; Nexus 4 Build/JOP40D) ' +
                    'AppleWebKit/535.19 (KHTML, like Gecko) ' +
                    'Chrome/18.0.1025.166 Mobile Safari/535.19'
      EnvironmentService.getOS().should.be 'android'

    it 'iOS', ->
      EnvironmentService.__set__ 'navigator',
        appVersion: '5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) ' +
                    'AppleWebKit/600.1.3 (KHTML, like Gecko)' +
                    'Version/8.0 Mobile/12A4345d Safari/600.1.4'
      EnvironmentService.getOS().should.be 'ios'

    it 'unknown', ->
      EnvironmentService.__set__ 'navigator',
        appVersion: 'something else'
      EnvironmentService.getOS().should.be 'unknown'
