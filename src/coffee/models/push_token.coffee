kik = require 'kik'
Q = require 'q'
log = require 'clay-loglevel'

resource = require '../lib/resource'
config = require '../config'
Game = require '../models/game'

resource.extendCollection 'pushTokens', (collection) ->
  collection.createForMarketplace = ->
    collection.createByGameId(null)

  collection.createByGameKey = (gameKey) ->
    Game.findOne(key: gameKey)
    .then (game) ->
      collection.createByGameId(game.id)

  collection.createByGameId = (gameId) ->
    Q.Promise (resolve, reject) ->
      # TODO: (Austin) remove localStorage in favor of anonymous user sessions
      if localStorage['pushTokenStored']
        reject new Error 'Token already created'
      else if kik && kik.ready && kik.push
        kik.ready ->
          kik.push.getToken (token) ->
            unless token
              return reject new Error 'No push token'
            collection.post
              gameId: gameId
              token: token
            .then ->
              localStorage['pushTokenStored'] = 1
              resolve()
            .catch (err) ->
              reject new Error err
              log.trace err
      else
        reject new Error 'Kik not loaded - unable to get push token'

  return collection

module.exports = resource.setBaseUrl(config.API_PATH).all('pushTokens')
