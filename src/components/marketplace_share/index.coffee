z = require 'zorium'
log = require 'clay-loglevel'
portal = require 'portal-gun'

User = require '../../models/user'
ShareService = require '../../services/share'

styles = require './index.styl'

MARKETPLACE_GAME_ID = '1'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  share: (e) ->
    e?.preventDefault()

    ShareService.any
      gameId: MARKETPLACE_GAME_ID
      text: 'Play with me! http://clay.io'
    .catch log.trace

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: =>
    z 'a.z-marketplace-share[href=#]', onclick: @share,
      z 'i.icon.icon-share'
