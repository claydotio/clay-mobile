z = require 'zorium'
_ = require 'lodash'

localstore = require '../lib/localstore'
config = require '../config'
request = require '../lib/request'
User = require '../models/user'

PATH = config.CLAY_API_URL + '/games'

class Game
  constructor: ->
    @editingGame = z.observe Promise.resolve null
    @editingGameId = null

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

  # FIXME: implement game component saves somewhere other than
  # onBeforeUnmount. Once that's done, remove this check. editingGame is
  # set to null here before the onBeforeUnmount, causing the save to fail
  # also remove in pages/dev_edit_game
  setEditingGameId: (gameId) =>
    @editingGameId = gameId

  getEditingGameId: =>
    return @editingGameId

  setEditingGame: (gamePromise) =>
    # FIXME: this gets called from page before onbeforeunmount, making it null
    @editingGame.set gamePromise

  updateEditingGame: (gameDiff) =>
    @setEditingGame @getEditingGame().then (game) ->
      _.defaults(gameDiff, game)

  getEditingGame: =>
    return @editingGame

  isStartComplete: (game) ->
    return game and game.key and game.name

  isDetailsComplete: (game) ->
    return game and
           game.description and
           (game.isDesktop or game.isMobile) and
           game.headerImage and
           game.iconImage and
           game.screenshotImages?.length >= config.SCREENSHOT_MIN_COUNT

  isUploadComplete: (game) ->
    return !!game?.gameUrl

  isApprovable: (game) =>
    return @isStartComplete(game) and
           @isDetailsComplete(game) and
           @isUploadComplete(game)

  updateById: (gameId, gameUpdate) ->
    User.getMe().then (me) ->
      request "#{PATH}/#{gameId}",
        method: 'PUT'
        qs:
          accessToken: me.accessToken
        body: gameUpdate

module.exports = new Game()
