z = require 'zorium'

localstore = require '../lib/localstore'
config = require '../config'
request = require '../lib/request'

PATH = config.CLAY_API_URL + '/games'

class Game
  getTop: ({limit, skip}) ->
    skip ?= 0
    limit ?= 10

    request PATH + '/top',
      qs: {limit, skip}

  getNew: ({limit, skip}) ->
    skip ?= 0
    limit ?= 10

    request PATH + '/new',
      qs: {limit, skip}

  find: (query) ->
    request PATH,
      qs: query

  findOne: (query) ->
    request PATH + '/findOne',
      qs: query

  get: (id) ->
    request PATH + "/#{id}"

  incrementPlayCount: (gameKey) ->
    unless typeof gameKey is 'string'
      return Promise.reject new Error 'invalid game key'

    gamePlayCountKey = "game:playCount:#{gameKey}"

    localstore.get gamePlayCountKey
    .then (gamePlayObject) ->
      gamePlayCount = if gamePlayObject?.count then gamePlayObject.count else 0
      localstore.set gamePlayCountKey, {count: gamePlayCount + 1}
    .then (gamePlayObject) ->
      gamePlayObject.count

  ###############
  # DEV METHODS #
  ###############

  create: ->
    request PATH,
      method: 'POST'

  editingGame: null

  setEditingGame: (gameId) =>
    @editingGame = @get gameId

  getEditingGame: ->
    return @editingGame

  uploadZip: -> null

  uploadMeta: -> null

  update: (gameId, {game}) -> null

  delete: (gameId) -> null

module.exports = new Game()
