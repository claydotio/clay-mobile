z = require 'zorium'

localstore = require '../lib/localstore'
config = require '../config'
request = require '../lib/request'
User = require '../models/user'

PATH = config.CLAY_API_URL + '/games'

class Game
  # TODO: (Zoli) Deprecate
  getTop: ({limit, skip}) ->
    skip ?= 0
    limit ?= 10

    request PATH + '/top',
      qs: {limit, skip}

  # TODO: (Zoli) Deprecate
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

  # TODO: (Zoli) rename
  get: (id) ->
    if _.isArray id
      id = id.join ','

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

  create: (developerId) ->
    User.getMe().then (me) ->
      request PATH,
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body: {developerId}

  editingGame: Promise.resolve null

  setEditingGame: (gameId) =>
    @editingGame = @get gameId

  getEditingGame: ->
    return @editingGame

  uploadZip: -> null

  uploadMeta: -> null

  isStartComplete: (game) ->
    return game.key and game.name

  isDetailsComplete: (game) ->
    return game.description and
           (game.isDesktop or game.isMobile) and
           game.headerImage and
           game.iconImage and
           game.screenshotImages?.length >= config.SCREENSHOT_MIN_COUNT

  isUploadComplete: (game) ->
    return !!game.gameUrl

  isApprovable: (game) =>
    return @isStartComplete(game) and
           @isDetailsComplete(game) and
           @isUploadComplete(game)

  update: (gameId, gameUpdate) ->
    User.getMe().then (me) ->
      request "#{PATH}/#{gameId}",
        method: 'PUT'
        qs:
          accessToken: me.accessToken
        body: gameUpdate


  delete: (gameId) -> null

module.exports = new Game()
