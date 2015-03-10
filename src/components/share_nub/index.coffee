z = require 'zorium'

Icon = require '../icon'
ShareService = require '../../services/share'
UrlService = require '../../services/url'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

share = (game) ->
  text = "Come play #{game.name} with me!
         #{UrlService.getMarketplaceGame({game})}"

  ShareService.any
    gameId: game.id
    text: text
  .catch log.trace

  ga? 'send', 'event', 'share_nub', 'share', game.key

module.exports = class ShareNub
  constructor: ->
    styles.use()

    @state = z.state
      $shareIcon: new Icon()

  render: ({game}) =>
    {$shareIcon} = @state()

    z 'div.z-share-nub', {
      onclick: (e) ->
        e.preventDefault()
        share game
        .catch log.trace
    },
      z $shareIcon,
        icon: 'share'
        color: styleConfig.$orange500
        isAlignedLeft: true
        isAlignedTop: true
