should = require('clay-chai').should()
rewire = require 'rewire'
Zock = new (require 'zock')()

PhoneService = rewire 'services/phone'
dialCodes = require 'lib/dial_codes.json'
urlRegex = require '../../lib/url_regex'

IP_INFO_URL = 'https://ipinfo.io'

describe 'PhoneService', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  describe 'normalizePhoneNumber()', ->
    before ->
      Zock
        .base(IP_INFO_URL)
        .get '/json'
        .reply 200, (res) ->
          return {country: 'US'}

    it '(xxx) xxx-xxxx', ->
      PhoneService.normalizePhoneNumber '(777) 777-7777'
      .then (normalizedPhone) ->
        normalizedPhone.should.be '+17777777777'

    it '+1 (xxx) xxx-xxxx', ->
      PhoneService.normalizePhoneNumber '+1 (777) 777-7777'
      .then (normalizedPhone) ->
        normalizedPhone.should.be '+17777777777'

    it 'xxx-xxx-xxxx', ->
      PhoneService.normalizePhoneNumber '777-777-7777'
      .then (normalizedPhone) ->
        normalizedPhone.should.be '+17777777777'

    it 'xxx.xxx.xxxx', ->
      PhoneService.normalizePhoneNumber '777.777.7777'
      .then (normalizedPhone) ->
        normalizedPhone.should.be '+17777777777'

    it 'xxx/xxx/xxxx', ->
      PhoneService.normalizePhoneNumber '777/777/7777'
      .then (normalizedPhone) ->
        normalizedPhone.should.be '+17777777777'

    it 'invalid international phone number', ->
      PhoneService.normalizePhoneNumber '+1abc'
      .then (normalizedPhone) ->
        normalizedPhone.should.be ''

    it 'invalid non-international phone number', ->
      PhoneService.normalizePhoneNumber 'abc'
      .then (normalizedPhone) ->
        normalizedPhone.should.be ''

    describe 'US', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'US'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+17777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+17777777777'

      it 'valid non-US international phone number', ->
        PhoneService.normalizePhoneNumber '+447777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+447777777777'

      it 'valid US phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+17777777777'

    describe 'UK', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'GB'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+447777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+447777777777'

      it 'valid 10-digit UK phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+447777777777'

      it 'valid 9-digit UK phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+44777777777'

    describe 'Canada', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'CA'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+17777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+17777777777'

      it 'valid Canada phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+17777777777'

    describe 'Australia', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'AU'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+617777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+617777777777'

      it 'valid AU phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+617777777777'

    describe 'Sweden', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'SE'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+467777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+467777777777'

      it 'valid Sweden phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+467777777777'

    describe 'Mexico', ->
      before ->
        Zock
          .base(IP_INFO_URL)
          .get '/json'
          .reply 200, (res) ->
            return {country: 'MX'}

      it 'valid international phone number', ->
        PhoneService.normalizePhoneNumber '+527777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+527777777777'

      it 'valid Mexico phone number (non-international)', ->
        PhoneService.normalizePhoneNumber '7777777777'
        .then (normalizedPhone) ->
          normalizedPhone.should.be '+527777777777'
