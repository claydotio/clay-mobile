kik = require 'kik'
log = require 'clay-loglevel'

User = require '../models/user'

class KikService
  shareGame: (game) ->
    User.getMe().then (user) ->
      User.getExperiments().then (params) ->

        big = params.kikShareImage is 'promo' or params.kikShareImage is 'icon'
        pic = if params.kikShareImage is 'promo' \
              then game.promo440Url
              else game.icon128Url

        kik?.send?(
          title: "Play #{game.name}!"
          text: game.description
          pic: pic
          big: big
          data: {gameKey: game.key, share: {originUserId: user.id}}
        )
    .catch (err) ->
      kik?.send?(
        title: "Play #{game.name}!"
        text: game.description
        pic: game.icon128Url
        data: {gameKey: game.key}
      )

      throw err

module.exports = new KikService()
