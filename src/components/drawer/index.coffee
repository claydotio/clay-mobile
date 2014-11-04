z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

config = require '../../config'
CrossPromotionBoxes = require '../cross_promotion'
CrossPromotionPromos = require '../cross_promotion/promos'
Nub = require '../nub'
Modal = require '../../models/modal'
User = require '../../models/user'
UrlService = require '../../services/url'
KikService = require '../../services/kik'

require './index.styl'

GAME_BOX_ICON_SIZE = 118
GAME_PROMO_WIDTH = 92
GAME_PROMO_HEIGHT = 59

module.exports = class Drawer
  constructor: ({@game, @theme}) ->
    @CrossPromotion = if @theme is 'orange' then \
      new CrossPromotionBoxes iconSize: GAME_BOX_ICON_SIZE
    else
      new CrossPromotionPromos
        gamePromoWidth: GAME_PROMO_WIDTH
        gamePromoHeight: GAME_PROMO_HEIGHT

    @Nub = new Nub
      theme: if @theme is 'orange' then 'transparent-menu' else 'control'
      onToggle: =>
        if @Nub.isOpen # drawer opened
          ga? 'send', 'event', 'drawer', 'open', @game.key
          User.convertExperiment 'drawer_open'

  close: (e) =>
    e?.preventDefault()
    @Nub.isOpen = false

  shareGame: (e) =>
    e?.preventDefault()
    KikService.shareGame @game
    .catch log.trace

    ga? 'send', 'event', 'drawer', 'share', @game.key

  openMarketplace: (e) =>
    e?.preventDefault()

    # if ga is loaded in, send the event, then load the marketplace
    if ga
      ga 'send', 'event', 'drawer', 'open_marketplace', @game.key,
        {hitCallback: @redirectToMarketplace}
    else
      @redirectToMarketplace()

  # technically we could use a URL to track (a la GA URL builder) BUT
  # Kik things pages with query params are a different app, and it's cleaner
  # to have all metrics we're tracking in a single format (events)

  # if already on marketplace, keep them there with root route, otherwise
  # hard redirect to marketplace
  redirectToMarketplace: ->
    if UrlService.isRootPath()
      z.route '/'
    else
      window.location.href = UrlService.getMarketplaceBase()

  render: =>
    if @Nub.isOpen
      drawerIsOpen = '.is-open'
      drawerOverlayIsOpen = '.is-open'
    else
      drawerIsOpen = ''
      drawerOverlayIsOpen = ''

    # TODO: (Austin) some sort of fast-click equivalent on top of mithril
    [
      z "div.drawer-overlay#{drawerOverlayIsOpen}",
        ontouchstart: @close

      if @theme is 'orange' then \
        z 'div.drawer-nub.theme-orange',
          @Nub.render()

      if @theme is 'orange' then \
        z "div.drawer#{drawerIsOpen}.theme-orange",
          z 'div.drawer-header',
            z 'a[href=#].drawer-close',
              onclick: @close,
              z 'i.icon.icon-close'
            z 'a[href=#{UrlService.getMarketplaceBase()].drawer-home',
              onclick: @openMarketplace,
              z 'i.icon.icon-home'
          z 'div.drawer-inner',
            z 'div.drawer-promo',
              style: "background-image: url(#{@game.promo440Url})",
              z 'div.drawer-promo-text',
                z 'div.drawer-promo-descriptor', "You're playing"
                z 'h1.drawer-promo-title', @game.name
            z 'div.drawer-content',
              z '.drawer-share',
                z 'div.drawer-share-inner',
                  z 'button.button-primary.is-block.drawer-share-button',
                    onclick: @shareGame,
                    z 'i.icon.icon-share'
                    'Share with friends'
              z "a[href=#{UrlService.getMarketplaceBase()}]
                .drawer-marketplace-link",
                onclick: @openMarketplace,
                z 'i.icon.icon-heart'
                z 'span.drawer-menu-item', 'Recommended games'
              z 'div.drawer-cross-promotion',
                @CrossPromotion.render()
                z 'button.button-secondary.is-block.drawer-browse-more',
                  onclick: @openMarketplace,
                  'Browse more games'
      else
        z "div.drawer#{drawerIsOpen}.theme-control",
          z 'div.drawer-nub', # nub moves with drawer
            @Nub.render()
          z 'div.drawer-header',
            z 'div.drawer-header-logo'
          z 'div.drawer-inner',
            z 'div.drawer-promo',
              style: "background-image: url(#{@game.promo440Url})"
            z 'div.drawer-content',
              z 'ul.drawer-menu-items',
                z 'li',
                  z 'a[href=#]', onclick: @shareGame,
                    z 'i.icon.icon-share'
                    z 'span.drawer-menu-item', 'Share game'
                z 'li.drawer-menu-divider'
                z 'li',
                  z "a[href=#{UrlService.getMarketplaceBase()}]",
                  onclick: @openMarketplace,
                    z 'i.icon.icon-market'
                    z 'span.drawer-menu-item', 'Browse more games'
              z 'div.drawer-cross-promotion',
                @CrossPromotion.render()
    ]
