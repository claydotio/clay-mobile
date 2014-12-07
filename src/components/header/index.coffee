z = require 'zorium'

MarketplaceShare = require '../marketplace_share'

styles = require './index.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @MarketplaceShare = new MarketplaceShare()

  render: ->
    z 'header.z-header',
      z.router.a '.z-header-logo[href=/]'
      z 'div.z-header-marketplace-share', @MarketplaceShare
