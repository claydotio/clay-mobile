should = require('clay-chai').should()
rewire = require 'rewire'
Joi = require 'joi'

InviteService = rewire 'services/invite'

urlRegex = require '../../lib/url_regex'

describe 'InviteService', ->

  it 'getUrl()', ->
    inviteUrl = InviteService.getUrl({userId: '123'})
    inviteUrl.should.match urlRegex
    inviteUrl.should.match /123/

  it 'sendFacebookInvite()', (done) ->
    oldOpen = window.open
    window.open = (url, windowName) ->
      window.open = oldOpen
      url.should.match urlRegex
      url.should.match /123/
      windowName.should.be '_system'
      done()

    InviteService.sendFacebookInvite({userId: '123'})

  it 'sendKikInvite()', (done) ->
    overrides =
      kik:
        send: (options) ->
          schema = Joi.object().keys
            title: Joi.string()
            text: Joi.string()
            data: Joi.object().keys
              fromUserId: Joi.string().valid '123'

          Joi.validate options, schema, {presence: 'required'}, (err) ->
            done err

    InviteService.__with__(overrides) ->
      InviteService.sendKikInvite({userId: '123'})

  it 'sendTwitterInvite()', (done) ->
    oldOpen = window.open
    window.open = (url, windowName) ->
      window.open = oldOpen
      url.should.match urlRegex
      url.should.match /123/
      windowName.should.be '_system'
      done()

    InviteService.sendTwitterInvite({userId: '123'})
