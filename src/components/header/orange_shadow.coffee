z = require 'zorium'

MarketplaceShare = require '../marketplace_share'

styles = require './orange_shadow.styl'

module.exports = class Header
  constructor: ->
    styles.use()

    @MarketplaceShare = new MarketplaceShare()

  render: ->
    z 'header.header',
      z 'a.header-logo[href=/]'
      z 'div.header-marketplace-share', @MarketplaceShare
