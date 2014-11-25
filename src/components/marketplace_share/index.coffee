z = require 'zorium'
log = require 'clay-loglevel'
portal = require 'portal-gun'

User = require '../../models/user'
PortalService = require '../../services/portal'

styles = require './index.styl'

MARKETPLACE_GAME_ID = '1'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  share: (e) ->
    e?.preventDefault()

    PortalService.get 'share.any',
      gameId: MARKETPLACE_GAME_ID
      text: 'Play with me! http://clay.io'

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: =>
    z 'a.marketplace-share', onclick: @share,
      z 'i.icon.icon-share'
