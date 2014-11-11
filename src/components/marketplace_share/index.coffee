z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
KikService = require '../../services/kik'

styles = require './index.styl'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  share: (e) ->
    e?.preventDefault()

    KikService.shareMarketplace()
    .catch log.trace

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: =>
    z 'a.marketplace-share', onclick: @share,
      z 'i.icon.icon-share'
