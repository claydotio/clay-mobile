rewire = require 'rewire'

ShareService = rewire 'services/share'

describe 'Shareservice', ->
  it 'shares via twitter if kik unavailable', (done) ->
    overrides =
      PortalService:
        call: ->
          Promise.reject new Error 'Method not handled'
    oldOpen = window.open
    window.open = (url) ->
      window.open = oldOpen
      url.should.be 'https://twitter.com/intent/tweet?text=HELLO'
      done()

    ShareService.__with__(overrides) ->
      ShareService.any
        text: 'HELLO'
        gameId: 1
    .catch done
