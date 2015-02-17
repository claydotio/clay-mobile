z = require 'zorium'

styles = require './index.styl'

MarketplaceShare = require '../marketplace_share'
NavDrawerModel = require '../../models/nav_drawer'

module.exports = class AppBar
  # height int
  # topLeftButton = 'menu', 'back', null
  # topRightButton = 'signin', 'share'
  # barType: descriptive - display title and description. min 168 high
  #          navigation - just title. min 56px high
  constructor: ->
    styles.use()

    @state = z.state
      $marketplaceShare: new MarketplaceShare()

  render: (
    {
      height
      barType
      paddingBottom
      topLeftButton
      topRightButton
      title
      description
    }
  ) =>
    {$marketplaceShare} = @state()

    isFixed = barType is 'navigation'
    isBackground = barType is 'background'
    isNavigation = barType is 'navigation'
    height ?= '56px'
    paddingBottom ?= 0
    barType ?= 'navigation'

    z 'header.z-app-bar', {
      className: z.classKebab {
        isFixed
        isBackground
        isNavigation
      }
      style: height: height
    },

      z 'div.orange-bar.l-flex.l-vertical-center', {
        style: height: height, paddingBottom: paddingBottom
      },
        if topLeftButton is 'menu'
          z 'a.menu', {
            onclick: (e) ->
              e?.preventDefault()
              NavDrawerModel.open()
          },
            z 'i.icon.icon-menu'
        else if topLeftButton is 'back'
          z 'i.icon.icon-back-arrow'

        if isNavigation
          z.router.link z 'a.logo[href=/]',
            'Clay'
            z 'span.io', '.io'

        if topRightButton is 'signin'
          z 'div', 'Sign In'
        else if topRightButton is 'share'
          z 'div.marketplace-share', $marketplaceShare

        if isBackground
          z 'div.content',
            z 'h1.title', title
            z 'h3.description', description
