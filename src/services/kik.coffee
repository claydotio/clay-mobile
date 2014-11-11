kik = require 'kik'
log = require 'clay-loglevel'

styleConfig = require '../stylus/vars.json'
User = require '../models/user'

class KikService
  shareMarketplace: ->
    User.getMe().then (user) ->
      User.getExperiments().then (params) ->
        kik?.send?(
          title: 'Free Games'
          text: 'Come play the best games on Kik with me!'
          pic: styleConfig.$icon256
          data: {share: {originUserId: user.id}}
        )
    .catch (err) ->
      kik?.send?(
        title: 'Free Games'
        text: 'Come play the best games on Kik with me!'
        pic: styleConfig.$icon256
        data: {}
      )

      throw err

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
