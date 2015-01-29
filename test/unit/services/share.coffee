rewire = require 'rewire'

ShareService = rewire 'services/share'

describe 'Shareservice', ->
  it 'shares via twitter if kik unavailable', (done) ->
    overrides =
      PortalService:
        beforeWindowOpen: -> null
        get: ->
          Promise.reject new Error 'Method not handled'
        windowOpen: (url) ->
          url.should.be 'https://twitter.com/intent/tweet?text=HELLO'
          done()

    ShareService.__with__(overrides) ->
      ShareService.any
        text: 'HELLO'
        gameId: 1
    .catch done
