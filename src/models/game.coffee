z = require 'zorium'
_ = require 'lodash'

localstore = require '../lib/localstore'
config = require '../config'
request = require '../lib/request'
User = require '../models/user'

PATH = config.PUBLIC_CLAY_API_URL + '/games'
LOCALSTORE_PLAY_COUNT_KEY_PREFIX = 'game:play_count'

class Game
  constructor: ->
    @o_editingGame = z.observe Promise.resolve null
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

  # TODO: (Austin) Deprecate
  findOne: (query) ->
    request PATH + '/findOne',
      qs: query

  # TODO: (Zoli) rename
  get: (id) ->
    if _.isArray id
      id = id.join ','

    request PATH + "/#{id}"

  getByKey: (key) =>
    @find({key}).then _.first

  incrementPlayCount: (gameKey) ->
    unless typeof gameKey is 'string'
      return Promise.reject new Error 'invalid game key'

    gamePlayCountKey = "#{LOCALSTORE_PLAY_COUNT_KEY_PREFIX}:#{gameKey}"

    localstore.get gamePlayCountKey
    .then (gamePlayObject) ->
      gamePlayCount = if gamePlayObject?.count then gamePlayObject.count else 0
      localstore.set gamePlayCountKey, {count: gamePlayCount + 1}
    .then (gamePlayObject) ->
      gamePlayObject.count

  getPlayCount: (gameKey) ->
    localstore.get "#{LOCALSTORE_PLAY_COUNT_KEY_PREFIX}:#{gameKey}"

  ###############
  # DEV METHODS #
  ###############

  create: ({developerId}) ->
    User.getMe().then (me) ->
      request PATH,
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body: {developerId}

  setEditingGame: (gamePromise) =>
    @o_editingGame.set gamePromise

  getEditingGame: =>
    return @o_editingGame

  updateEditingGame: (gameDiff) =>
    @setEditingGame @getEditingGame().then (game) ->
      _.defaults(gameDiff, game)

  saveEditingGame: =>
    @getEditingGame().then (game) =>
      @updateById game.id, game

  isStartComplete: (game) ->
    return Boolean game and game.key and game.name

  isDetailsComplete: (game) ->
    return Boolean game and
           game.description and
           (game.isDesktop or game.isMobile) and
           game.headerImage and
           game.iconImage and
           game.screenshotImages?.length >= config.SCREENSHOT_MIN_COUNT

  isUploadComplete: (game) ->
    return Boolean game?.gameUrl

  isApprovable: (game) =>
    return Boolean @isStartComplete(game) and
           @isDetailsComplete(game) and
           @isUploadComplete(game)

  updateById: (gameId, gameUpdate) ->
    isPublishAction = _.size(gameUpdate) is 1 and gameUpdate.status
    unless isPublishAction
      links = _.pick gameUpdate, [
                'screenshotImages'
              ]
      gameUpdate = _.pick gameUpdate, [
                     'name'
                     'key'
                     'category'
                     'description'
                     'orientation'
                     'isDesktop'
                     'isMobile'
                     'links'
                   ]
      gameUpdate.links = links

    User.getMe().then (me) ->
      request "#{PATH}/#{gameId}",
        method: 'PUT'
        qs:
          accessToken: me.accessToken
        body: gameUpdate

module.exports = new Game()
