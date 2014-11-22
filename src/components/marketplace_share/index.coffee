z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
KikService = require '../../services/kik'
NativeService = require '../../services/native'

styles = require './index.styl'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  share: (e) ->
    e?.preventDefault()

    # TODO: (Austin) replace with impact hammer
    Promise.all [
      # FIXME: Don't even load Kik on non-kik - they could very well make
      # getUser return something in a new version of Kik
      # (they did with kik.send)
      Promise.resolve kik?.getUser
      NativeService.validateParent()
    ]
    .then ([isKik, isAndroidApp]) ->
      if isKik
        KikService.shareMarketplace()
        .catch log.trace
      else if isAndroidApp
        NativeService.shareMarketplace()
        .catch log.trace
      else
        tweet = 'Play some fun games with me! http://clay.io'
        window.open "https://twitter.com/intent/tweet?text=#{tweet}"

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: =>
    z 'a.marketplace-share', onclick: @share,
      z 'i.icon.icon-share'
