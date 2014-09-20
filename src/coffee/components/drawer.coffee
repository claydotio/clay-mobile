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

    if @isOpen # drawer opened
      ga? 'send', 'event', 'drawer', 'open', @game.key

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

    ga? 'send', 'event', 'drawer', 'share', @game.key

  rateGame: (e) =>
    e?.preventDefault()
    @close()
    Modal.openComponent @GameRate

  openMarketplace: (e) =>
    e?.preventDefault()

    # technically we could use a URL to track (a la GA URL builder) BUT
    # Kik things pages with query params are a different app, and it's cleaner
    # to have all metrics we're tracking in a single format (events)

    # if already on marketplace, keep them there with root route, otherwise
    # hard redirect to marketplace
    redirect = ->
      if UrlService.isRootPath()
        z.route '/'
      else
        window.location.href = UrlService.getMarketplaceBase()

    # if ga is loaded in, send the event, then load the marketplace
    if ga
      ga 'send', 'event', 'drawer', 'open_marketplace', @game.key,
        {hitCallback: redirect}
    else
      redirect()

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
      z "div.drawer-overlay#{drawerOverlayIsOpen}",
        ontouchstart: @toggleOpenState
      z "div.drawer#{drawerIsOpen}",
        z 'div.drawer-nub-padding', ontouchstart: @toggleOpenState,
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
                onclick: @openMarketplace,
                  z 'i.icon.icon-market'
                  z 'span.drawer-menu-item', 'Browse more games'
            z 'div.drawer-cross-promotion',
              @CrossPromotion.render()
    ]
