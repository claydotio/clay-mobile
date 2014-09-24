# _ = require 'lodash'
# Q = require 'q'
# should = require('clay-chai').should()
# proxyquire = require('clay-proxyquireify')(require)
#
# SDKDir = proxyquire 'directives/sdk',
#   kik:
#     message: 'testmsg'
#
# emit = (message) ->
#   Q.Promise (resolve, reject) ->
#     event = document.createEvent 'Event'
#     event.initEvent 'message', false, false
#     event.data = JSON.stringify message
#     event.source = {
#       postMessage: (res, target) ->
#         target.should.be '*'
#         resolve JSON.parse res
#     }
#
#     window.dispatchEvent event
#
#
# describe.only 'SDKDir', ->
#   before ->
#     directive = new SDKDir()
#     $el = document.createElement 'div'
#     ctx = {onunload: _.noop}
#     directive.config $el, false, ctx
#
#   it 'pong()', ->
#     emit {method: 'ping', _id: 1}
#     .then (res) ->
#       res._id.should.be 1
#
#   it 'auth.getStatus()', ->
#     emit {method: 'auth.getStatus'}
#     .then (res) ->
#       res.accessToken.should.be 1
#
#   it 'kik.getMessage()', ->
#     emit {method: 'kik.getMessage'}
#     .then (res) ->
#       console.log res
