z = require 'zorium'

styles = require './index.styl'

MarketplaceShare = require '../marketplace_share'
Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

module.exports = class AppBar
  constructor: ->
    styles.use()

  render: ({height, isDescriptive, overlapBottomPadding, $topLeftButton,
            $topRightButton, title, description}) ->

    # TODO: (Austin) smarter app bar
    # https://github.com/Zorium/zorium-site/blob/master/src/components/header/index.coffee
    isFixed = isDescriptive
    height ?= "#{styleConfig.$appBarHeightShort}px"
    # we could potentially make this an observable inside of a model to
    # share state between AppBar and the overlapping component(s)
    overlapBottomPadding ?= 0

    z 'header.z-app-bar', {
      className: z.classKebab {
        isFixed: not isDescriptive
        isDescriptive
      }
      style:
        height: height
    },

      z 'div.orange-bar', {
        style:
          height: height
          paddingBottom: overlapBottomPadding
      },
        z 'div.top',
          z 'div.top-left-button', $topLeftButton

          unless isDescriptive
            z.router.link z 'a.title[href=/]',
              if title
                title
              else
                [
                  'Clay'
                  z 'span.io', '.io'
                ]

          z 'div.top-right-button', $topRightButton

        if isDescriptive
          z 'div.content',
            z 'h1.title', title
            z 'h3.description', description
