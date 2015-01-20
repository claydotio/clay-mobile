kik = require 'kik'
log = require 'clay-loglevel'

styleConfig = require '../stylus/vars.json'
User = require '../models/user'

KIK_PUSH_HANDLER_TIMEOUT = 250

class KikService
  constructor: ->
    @isFromPushPromise = null

  isFromPush: =>
    unless @isFromPushPromise
      @isFromPushPromise = new Promise (resolve, reject) ->
        kik?.push?.handler ->
          resolve true
        setTimeout (-> resolve false), KIK_PUSH_HANDLER_TIMEOUT

    return @isFromPushPromise

  shareMarketplace: ->
    User.getMe().then (user) ->
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
      kik?.send?(
        title: "Play #{game.name}!"
        text: game.description
        pic: game.headerImage?.versions[0].url or game.promo440Url
        big: true
        data: {gameKey: game.key, share: {originUserId: user.id}}
      )
    .catch (err) ->
      kik?.send?(
        title: "Play #{game.name}!"
        text: game.description
        pic: game.iconImage?.versions[0].url or game.icon128Url
        data: {gameKey: game.key}
      )

      throw err

module.exports = new KikService()
