portal = require 'portal-gun'
_ = require 'lodash'
kik = require 'kik'

User = require '../models/user'
Game = require '../models/game'
Modal = require '../models/modal'
EnvironmentService = require './environment'
ShareAnyModal = require '../components/share_any_modal'

class PortalService
  constructor: ->
    portal.up()

  get: portal.get

  beforeWindowOpen: portal.beforeWindowOpen

  windowOpen: portal.windowOpen

  registerMethods: =>
    portal.register 'auth.getStatus', @authGetStatus
    portal.register 'share.any', @shareAny

    portal.register 'kik.isEnabled', -> EnvironmentService.isKikEnabled()
    portal.register 'kik.getMessage', -> kik?.message
    portal.register 'kik.send', -> kik?.send.apply null, arguments
    portal.register 'kik.browser.setOrientationLock', ->
      kik?.browser.setOrientationLock.apply null, arguments
    portal.register 'kik.metrics.enableGoogleAnalytics', ->
      kik?.metrics.enableGoogleAnalytics.apply null, arguments
    portal.register 'kik.getUser', ->
      new Promise (resolve) ->
        kik?.getUser resolve


  ###
  @typedef AuthStatus
  @property {String} accessToken
  @property {String} userId
  ###

  ###
  @returns {Promise<AuthStatus>}
  ###
  authGetStatus: ->
    User.getMe().then (user) ->
      accessToken: user.id # Temporary
      userId: user.id

  shareAny: ({text, gameId}) ->
    Promise.all [
      Game.get(gameId)
      User.getMe()
      User.getExperiments()
    ]
    .then ([game, me, experiments]) ->
      # WARNING: this is not tracked if game is played inside native app

      if experiments.shareModal is 'modal'
        ga? 'send', 'event', 'share_modal', 'open', game.key
        $shareAnyModal = new ShareAnyModal({text, game})
        Modal.openComponent(
          component: $shareAnyModal
        )
      else
        ga? 'send', 'event', 'game', 'share', game.key

        if EnvironmentService.isKikEnabled()
          kik.send
            title: "#{game.name}"
            text: text
            data:
              gameKey: "#{game.key}"
              share:
                originUserId: me.id
        else
          console.log 'no handlers found'
          throw new Error 'No handlers found'

      return null

module.exports = new PortalService()
