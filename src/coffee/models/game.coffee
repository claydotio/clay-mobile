resource = require '../lib/resource'
config = require '../config'

resource.extendCollection 'games', (collection) ->
  collection.getTop = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    @customGETLIST('top', {limit: limit, skip: skip})

  collection.getNew = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    @customGETLIST('new', {limit: limit, skip: skip})

  collection.findOne = (query) ->
    @customGET('findOne', query)

  return collection

module.exports = resource.setBaseUrl(config.API_PATH).all('games')
