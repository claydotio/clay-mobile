z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
ShareService = require '../../services/share'
Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

MARKETPLACE_GAME_ID = '1'

module.exports = class MarketplaceShareButton
  constructor: ->

    @state = z.state
      $shareIcon: new Icon()

  share: (e) ->
    e?.preventDefault()

    ShareService.any
      text: 'Play with me! http://clay.io'
    .catch log.trace

    ga? 'send', 'event', 'marketplace_share', 'share', 'marketplace'
    User.convertExperiment 'marketplace_share'
    .catch log.trace

  render: ({isAlignedRight}) =>
    {$shareIcon} = @state()

    z 'div.z-marketplace-share-button',
      z $shareIcon,
        isAlignedRight: isAlignedRight
        icon: 'share'
        color: styleConfig.$white
        onclick: @share
