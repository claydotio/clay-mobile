resource = require '../lib/resource'
config = require '../config'

resource.extendCollection 'pushTokens', (collection) ->

  collection.create = ({token, source}) ->
    @customPOST( { token: token, source: source }, '' ) # post to pushTokens/

  return collection

module.exports = resource.setBaseUrl config.API_PATH
