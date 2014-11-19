z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

config = require '../../config'
CrossPromotion = require '../cross_promotion'
GooglePlayAdDrawerControl = require '../google_play_ad_drawer'
GooglePlayAdDrawerInstallButton =
  require '../google_play_ad_drawer/install_button'
Nub = require '../nub'
Modal = require '../../models/modal'
User = require '../../models/user'
UrlService = require '../../services/url'
KikService = require '../../services/kik'
NativeService = require '../../services/native'
EnvironmentService = require '../../services/environment'

styles = require './index.styl'

GAME_BOX_ICON_SIZE = 118

module.exports = class Drawer
  constructor: ({@game}) ->
    styles.use()

    @isOpen = false

    @CrossPromotion = new CrossPromotion iconSize: GAME_BOX_ICON_SIZE
    @Nub = new Nub toggleCallback: @toggleState

    @GooglePlayAdDrawer = null
    User.getExperiments().then (params) =>
      @GooglePlayAdDrawer = if params.googlePlayDrawer is 'install-button' \
                            then new GooglePlayAdDrawerInstallButton()
                            else new GooglePlayAdDrawerControl()
    .then z.redraw

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

  shareGame: (e) =>
    e?.preventDefault()

    EnvironmentService.getPlatform().then (platform) =>
      switch platform
        when 'kik'
          KikService.shareGame @game
          .catch log.trace
        when 'androidApp'
          NativeService.shareGame @game
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
      z "div.drawer-overlay#{drawerOverlayIsOpen}",
        ontouchstart: @close
      z 'div.drawer-nub',
        @Nub
      z "div.drawer#{drawerIsOpen}",
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
            z 'div.z-drawer-google-play-ad-drawer', @GooglePlayAdDrawer
            z "a[href=#{UrlService.getMarketplaceBase()}]
              .drawer-marketplace-link",
              onclick: @openMarketplace,
              z 'i.icon.icon-heart'
              z 'span.drawer-menu-item', 'Recommended games'
            z 'div.drawer-cross-promotion',
              @CrossPromotion
              z 'button.button-secondary.is-block.drawer-browse-more',
                onclick: @openMarketplace,
                'Browse more games'
    ]
