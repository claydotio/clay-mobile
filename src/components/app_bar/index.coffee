z = require 'zorium'

styles = require './index.styl'

MarketplaceShare = require '../marketplace_share'
Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

module.exports = class AppBar
  # height <int>
  # topLeftButton <string> 'menu', 'back', null
  # topRightButton <string> 'signin', 'share'
  # barType <string> 'descriptive' - display title and description. min 168 high
  #                  'navigation' - just title. min 56px high
  constructor: ->
    styles.use()

    @state = z.state
      $marketplaceShare: new MarketplaceShare()
      $menuIcon: new Icon()
      $backIcon: new Icon()

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
    {$marketplaceShare, $menuIcon, $backIcon} = @state()

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

      z 'div.orange-bar.l-flex', {
        style: height: height, paddingBottom: paddingBottom
      },
        z 'div.top.l-flex.l-vertical-center',
          z 'div.top-left-button',
            if topLeftButton is 'menu'
              z 'a[href=#].menu', {
                onclick: (e) ->
                  e?.preventDefault()
                  NavDrawerModel.open()
              },
                z $menuIcon,
                  icon: 'menu'
                  size: '24px'
                  color: styleConfig.$white
            else if topLeftButton is 'back'
              z 'a[href=#].back', {
                onclick: (e) ->
                  e?.preventDefault()
                  window.history.back()
              },
                z $backIcon,
                  icon: 'arrowBack'
                  size: '24px'
                  color: styleConfig.$white

          if isNavigation
            z.router.link z 'a.logo[href=/]',
              if title
                title
              else
                [
                  'Clay'
                  z 'span.io', '.io'
                ]

          z 'div.top-right-button',
            if topRightButton is 'signin'
              z.router.link z 'a[href=/login].sign-in', 'Sign In'
            else if topRightButton is 'signup'
              z.router.link z 'a[href=/join].sign-in', 'Sign Up'
            else if topRightButton is 'share'
              z 'div.marketplace-share', $marketplaceShare

        if isBackground
          z 'div.content',
            z 'h1.title', title
            z 'h3.description', description
