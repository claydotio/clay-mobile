resource = require '../lib/resource'
config = require '../config'

resource.extendCollection 'games', (collection) ->
  collection.getTop = -> @customGET('top')
  collection.getNew = -> @customGET('new')

  return collection

module.exports = resource.setBaseUrl config.API_URL