z = require 'zorium'

styles = require './index.styl'

MarketplaceShare = require '../marketplace_share'

UNIT_HEIGHT_PX = 56

module.exports = class AppBar
  # navButton = 'menu', 'back', null
  constructor: ({heightUnits, barType, navButton}) ->
    styles.use()

    @state = z.state
      $marketplaceShare: new MarketplaceShare()
      heightUnits: heightUnits
      barType: barType
      navButton: navButton

  render: ({$marketplaceShare, heightUnits, barType, navButton}) ->
    z 'header.z-app-bar',
      z '.orange-bar', {style: height: (heightUnits * UNIT_HEIGHT_PX) + 'px'},

        if navButton is 'menu'
          null
        else if navButton is 'back'
          null
        else
          z 'i.icon.icon-back-arrow'

        if barType is 'background'
          z 'div.is-background',
            z 'h1.title', 'Invite Friends'
            z 'h3.description', 'Build your friends list, see what they play.'
        else
          z 'div.is-navigation',
            z.router.link z 'a.logo[href=/]'
            z 'div.marketplace-share', $marketplaceShare
