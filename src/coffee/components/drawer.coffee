z = require 'zorium'

config = require '../config'
CrossPromotion = require './cross_promotion'
GameRate = require './game_rate'
Modal = require '../models/modal'
UrlService = require '../services/url'

GAME_PROMO_WIDTH = 92
GAME_PROMO_HEIGHT = 59

module.exports = class Drawer
  constructor: ({@game}) ->
    crossPromotionOptions =
      gamePromoWidth: GAME_PROMO_WIDTH
      gamePromoHeight: GAME_PROMO_HEIGHT
    @CrossPromotion = new CrossPromotion crossPromotionOptions
    @GameRate = new GameRate {@game, onRated: -> Modal.closeComponent()}

  isOpen: false
  toggleOpenState: (e) =>
    e?.stopPropagation()
    @isOpen = not @isOpen
    z.redraw()

  close: (e) =>
    e?.stopPropagation()
    @isOpen = false

  shareGame: (e) =>
    e?.preventDefault()
    kik?.send?(
      title: "Play #{@game.name}!"
      text: @game.description
      pic: @game.icon128Url
      data: {gameKey: @game.key}
    )

  rateGame: (e) =>
    e?.preventDefault()
    @close()
    Modal.openComponent @GameRate

  render: =>
    # drawer state
    if @isOpen
      drawerIsOpen = '.is-open'
      drawerOverlayIsOpen = '.is-open'
      chevronDirection = 'right'
    else
      drawerIsOpen = ''
      drawerOverlayIsOpen = ''
      chevronDirection = 'left'

    [
      # TODO: (Austin) some sort of fast-click equivalent on top of mithril
      z "div.drawer-overlay#{drawerIsOpen}", ontouchstart: @toggleOpenState
      z "div.drawer#{drawerOverlayIsOpen}",
        z 'div.drawer-nub-padding', onclick: @toggleOpenState,
          z 'div.drawer-nub',
            z "i.icon.icon-chevron-#{chevronDirection}"
        z 'div.drawer-header',
          # making the logo link to Clay causes too many mis-clicks on close nub
          z 'div.drawer-header-logo'
        z 'div.drawer-inner',
          z 'div.drawer-promo-image',
            style: "background-image: url(#{@game.promo440Url})"
          z 'div.drawer-content',
            z 'ul.drawer-menu-items',
              z 'li',
                z 'a[href=#]', onclick: @shareGame,
                  z 'i.icon.icon-share'
                  z 'span.drawer-menu-item', 'Share game'
              # TODO: (Austin) Re-enable when we have user accounts
              #z 'li',
                #z 'a[href=#]', onclick: @rateGame,
                  #z 'i.icon.icon-star'
                  #z 'span.drawer-menu-item', 'Rate game'
              z 'li.divider'
              z 'li',
                z "a[href=#{UrlService.getMarketplaceBase()}]",
                  z 'i.icon.icon-market'
                  z 'span.drawer-menu-item', 'Browse more games'
            z 'div.drawer-cross-promotion',
              @CrossPromotion.render()
    ]
