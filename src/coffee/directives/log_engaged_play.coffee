log = require 'clay-loglevel'
Experiment = require '../models/experiment'

ENGAGED_PLAY_TIME = 60000 # 1 min

# FIXME: this directive shouldn't exist. it's our short-term solution to
# onunload not working properly for components. Once we have a better
# beforeUnload solution for components, use that, get rid of this
module.exports = class LogEngagedPlay
  constructor: (@gameKey) -> null

  config: ($el, isInit, ctx) =>

    # run once
    if isInit
      return

    # log an engaged play (stays on this page for > 1 min)
    logEngagedPlay = =>
      Experiment.convert('engaged_play').catch log.trace
      ga? 'send', 'event', 'game', 'engaged_play', @gameKey
    @engagedPlayTimeout = window.setTimeout logEngagedPlay, ENGAGED_PLAY_TIME

    ctx.onunload = =>
      window.clearTimeout @engagedPlayTimeout
