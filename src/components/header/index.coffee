z = require 'zorium'

MarketplaceShare = require '../marketplace_share'

styles = require './index.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @MarketplaceShare = new MarketplaceShare()

  render: ->
    z 'header.z-header',
      z '.orange-bar',
        z.router.a '.logo[href=/]'
        z 'div.marketplace-share', @MarketplaceShare
