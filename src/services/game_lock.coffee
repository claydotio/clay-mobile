User = require '../models/user'
EnvironmentService = require './environment'
localstore = require '../lib/localstore'
config = require '../config'

LOCALSTORE_GAME_LOCK_PREFIX = 'game_lock'

# Dev uses lower id's because games may be missing from local db
LOCKED_GAME_ID = if config.ENV is config.ENVS.DEV \
  then '405' # turkeytumble
  else '5278' # mancala

class GameLockService
  isLocked: (game) ->
    User.getExperiments().then ({gameLock}) ->
      if gameLock is 'locked' and EnvironmentService.isKikEnabled() and
      game.id is LOCKED_GAME_ID
        return localstore.get LOCALSTORE_GAME_LOCK_PREFIX + ':' + game.id
        .then (lock) ->
          unless lock
            return true
          return lock.isLocked isnt false
      else
        return false

  unlock: (game) ->
    localstore.set LOCALSTORE_GAME_LOCK_PREFIX + ':' + game.id,
    {isLocked: false}


module.exports = new GameLockService()
