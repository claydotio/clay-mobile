log = require 'clay-loglevel'
User = require '../models/user'

ENGAGED_PLAY_TIME = 60000 # 1 min

# FIXME: this directive shouldn't exist. it's our short-term solution to
# onunload not working properly for components. Once we have a better
# beforeUnload solution for components, use that, get rid of this
module.exports = class LogEngagedPlay
  constructor: (@game) -> null

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    # log an engaged play (stays on this page for > 1 min)
    logEngagedPlay = =>
      User.convertExperiment('engaged_play').catch log.trace
      ga? 'send', 'event', 'game', 'engaged_play', @game.key
      User.addRecentGame(@game.id).catch log.trace

    @engagedPlayTimeout = window.setTimeout logEngagedPlay, ENGAGED_PLAY_TIME

    ctx.onunload = =>
      window.clearTimeout @engagedPlayTimeout
