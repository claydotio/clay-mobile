resource = require '../lib/resource'
localstore = require '../lib/localstore'
config = require '../config'

resource.extendCollection 'games', (collection) ->
  collection.getTop = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    collection.customGETLIST('top', {limit: limit, skip: skip})

  collection.getNew = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    collection.customGETLIST('new', {limit: limit, skip: skip})

  collection.findOne = (query) ->
    collection.customGET('findOne', query)

  collection.incrementPlayCount = (gameKey) ->
    gamePlayCountKey = "game:playCount:#{gameKey}"
    localstore.get gamePlayCountKey
    .then (gamePlayObject) ->
      gamePlayCount = if gamePlayObject?.count then gamePlayObject.count else 0
      localstore.set gamePlayCountKey, {count: gamePlayCount + 1}
    .then (gamePlayObject) ->
      gamePlayObject.count

  return collection

module.exports = resource.setBaseUrl(config.API_PATH).all('games')
