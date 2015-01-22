portal = require 'portal-gun'
_ = require 'lodash'
kik = require 'kik'

User = require '../models/user'
Game = require '../models/game'
EnvironmentService = require './environment'


class PortalService
  constructor: ->
    portal.up()

  get: portal.get

  registerMethods: =>
    portal.register 'auth.getStatus', @authGetStatus
    portal.register 'share.any', @shareAny

    portal.register 'kik.isEnabled', -> EnvironmentService.isKikEnabled()
    portal.register 'kik.send', -> kik.send.apply null, arguments
    portal.register 'kik.browser.setOrientationLock', ->
      kik.browser.setOrientationLock.apply null, arguments
    portal.register 'kik.metrics.enableGoogleAnalytics', ->
      kik.metrics.enableGoogleAnalytics.apply null, arguments


  ###
  @typedef AuthStatus
  @property {String} accessToken
  ###

  ###
  @returns {Promise<AuthStatus>}
  ###
  authGetStatus: ->
    User.getMe().then (user) ->
      accessToken: String user.id

  shareAny: ({text, gameId}) ->
    tweet = (text) ->
      text = encodeURIComponent text.substr 0, 140
      window.open "https://twitter.com/intent/tweet?text=#{text}"

    Game.get(gameId)
    .then (game) ->
      unless game
        throw new Error 'gameId invalid'

      if EnvironmentService.isKikEnabled()
        kik.send
          title: "#{game.name}"
          text: text
          data:
            gameKey: "#{game.key}"
      else
        tweet(text)

      return null
    .catch (err) ->
      tweet(text)
      log.trace err
      return null

module.exports = new PortalService()
