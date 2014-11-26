z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

config = require '../../config'
CrossPromotion = require '../cross_promotion'
Nub = require '../nub'
Modal = require '../../models/modal'
User = require '../../models/user'
UrlService = require '../../services/url'
PortalService = require '../../services/portal'

styles = require './index.styl'

GAME_BOX_ICON_SIZE = 118

module.exports = class Drawer
  constructor: ({@game}) ->
    styles.use()

    @isOpen = false

    @CrossPromotion = new CrossPromotion iconSize: GAME_BOX_ICON_SIZE

    @Nub = new Nub toggleCallback: @toggleState

  toggleState: (e) =>
    e?.preventDefault()

    @isOpen = not @isOpen

    if @isOpen
      ga? 'send', 'event', 'drawer', 'open', @game.key

    # This is a workaround for this Mithril issue:
    # https://github.com/lhorie/mithril.js/issues/273
    # Without this, if the game iframe is clicked before the drawer nub
    # then the iframe is re-loaded because it is the activeElement
    # during the Mithril DOM-diff
    window.document.activeElement?.blur()
    z.redraw()

  close: (e) =>
    e?.preventDefault()
    @isOpen = false
    z.redraw()

  shareGame: (e) =>
    e?.preventDefault()

    text = "Come play #{@game.name} with me!
           #{UrlService.getMarketplaceGame({@game})}"

    PortalService.get 'share.any',
      gameId: @game.id
      text: text

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
      z.router.go '/'
    else
      window.location.href = UrlService.getMarketplaceBase()

  render: =>
    if @isOpen
      drawerIsOpen = '.is-open'
      drawerOverlayIsOpen = '.is-open'
    else
      drawerIsOpen = ''
      drawerOverlayIsOpen = ''

    # TODO: (Austin) some sort of fast-click equivalent on top of mithril
    [
      z "div.z-drawer-overlay#{drawerOverlayIsOpen}",
        ontouchstart: @close
      z 'div.z-drawer-nub',
        @Nub
      z "div.z-drawer#{drawerIsOpen}",
        z 'div.z-drawer-header',
          z 'a[href=#].z-drawer-close',
            onclick: @close,
            z 'i.icon.icon-close'
          z 'a[href=#{UrlService.getMarketplaceBase()].z-drawer-home',
            onclick: @openMarketplace,
            z 'i.icon.icon-home'
        z 'div.z-drawer-inner',
          z 'div.z-drawer-promo',
            style:
              backgroundImage: "url(#{@game.promo440Url})",
            z 'div.z-drawer-promo-text',
              z 'div.z-drawer-promo-descriptor', "You're playing"
              z 'h1.z-drawer-promo-title', @game.name
          z 'div.z-drawer-content',
            z '.z-drawer-share',
              z 'div.z-drawer-share-inner',
                z 'button.button-primary.is-block.z-drawer-share-button',
                  onclick: @shareGame,
                  z 'i.icon.icon-share'
                  'Share with friends'
            z "a[href=#{UrlService.getMarketplaceBase()}]
              .z-drawer-marketplace-link",
              onclick: @openMarketplace,
              z 'i.icon.icon-heart'
              z 'span.z-drawer-menu-item', 'Recommended games'
            z 'div.z-drawer-cross-promotion',
              @CrossPromotion
              z 'button.button-secondary.is-block.z-drawer-browse-more',
                onclick: @openMarketplace,
                'Browse more games'
    ]
