z = require 'zorium'

MarketplaceShare = require '../marketplace_share'

styles = require './index.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @state = z.state
      $marketplaceShare: new MarketplaceShare()

  render: =>
    {$marketplaceShare} = @state()
    z 'header.z-header',
      z '.orange-bar',
        z.router.link z 'a.logo[href=/]'
        z 'div.marketplace-share', $marketplaceShare
