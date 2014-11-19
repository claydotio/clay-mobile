z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
KikService = require '../../services/kik'
NativeService = require '../../services/native'
EnvironmentService = require '../../services/environment'

styles = require './index.styl'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  share: (e) ->
    e?.preventDefault()

    EnvironmentService.getPlatform().then (platform) ->
      switch platform
        when 'kik'
          KikService.shareMarketplace()
          .catch log.trace
        when 'androidApp'
          NativeService.shareMarketplace()
          .catch log.trace

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: =>
    z 'a.marketplace-share', onclick: @share,
      z 'i.icon.icon-share'
