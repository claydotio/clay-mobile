z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

config = require '../../config'
CrossPromotion = require '../cross_promotion'
GooglePlayAdDrawer = require '../google_play_ad_drawer'
Nub = require '../nub'
Icon = require '../icon'
UrlService = require '../../services/url'
ShareService = require '../../services/share'
GooglePlayAdService = require '../../services/google_play_ad'
PortalService = require '../../services/portal'
Game = require '../../models/game'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

GAME_BOX_ICON_SIZE = 118

module.exports = class Drawer
  constructor: ({game}) ->
    styles.use()

    @state = z.state
      game: game
      isOpen: false
      $messengerIcon: new Icon()
      $shareIcon: new Icon()
      $crossPromotion: new CrossPromotion()
      $nub: new Nub toggleCallback: @toggleState
      $googlePlayAdDrawer: if GooglePlayAdService.shouldShowAds() \
                          then new GooglePlayAdDrawer()
                          else null
      isMessengerInstalled: z.observe PortalService.call 'messenger.isInstalled'

  toggleState: (e) =>
    e?.preventDefault()

    {isOpen, game} = @state()

    if not isOpen
      ga? 'send', 'event', 'drawer', 'open', game.key

    @state.set isOpen: not isOpen

  close: (e) =>
    e?.preventDefault()
    @state.set isOpen: false

  shareGame: (e) =>
    e?.preventDefault()

    {game} = @state()

    text = "Come play #{game.name} with me!
           #{UrlService.getMarketplaceGame({game})}"

    ShareService.any
      game: game
      text: text
    .catch log.trace

    ga? 'send', 'event', 'drawer', 'share', game.key

  openMarketplace: (e) =>
    e?.preventDefault()

    {game} = @state()

    # if ga is loaded in, send the event, then load the marketplace
    if ga
      ga 'send', 'event', 'drawer', 'open_marketplace', game.key,
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
    {isOpen, game, $nub, $googlePlayAdDrawer, $crossPromotion,
      $messengerIcon, $shareIcon, isMessengerInstalled} = @state()

    if isOpen
      drawerIsOpen = '.is-open'
      drawerOverlayIsOpen = '.is-open'
    else
      drawerIsOpen = ''
      drawerOverlayIsOpen = ''

    headerImageUrl = Game.getHeaderImageUrl game

    drawerWidth = 288
    drawerNubRadius = 48
    translateX = if isOpen then '0' else "#{window.innerWidth}px"


    # TODO: (Austin) some sort of fast-click equivalent on top of zorium
    [
      z "div.z-drawer-overlay#{drawerOverlayIsOpen}",
        ontouchstart: @close
      z 'div.z-drawer-nub', {
        style:
          width: "#{drawerNubRadius}px"
      },
        $nub
      z "div.z-drawer#{drawerIsOpen}", {
        style:
          width: "#{drawerWidth}px"
          transform: "translate(#{translateX}, 0)"
          webkitTransform: "translate(#{translateX}, 0)"
      },
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
              backgroundImage: "url(#{headerImageUrl})",
            z 'div.z-drawer-promo-text',
              z 'div.z-drawer-promo-descriptor', "You're playing"
              z 'h1.z-drawer-promo-title', game.name
          z 'div.z-drawer-content',
            z '.z-drawer-share',
              z 'div.z-drawer-share-inner',
                z 'button.button-primary.z-drawer-share-button', {
                  className: z.classKebab {isMessenger: isMessengerInstalled}
                  onclick: @shareGame
                },
                  if isMessengerInstalled \
                  then [
                    z '.icon',
                      z $messengerIcon,
                        icon: 'messenger-bubble'
                        isTouchTarget: false
                        color: styleConfig.$white
                    z '.text', 'Send to Messenger'
                  ]
                  else [
                    z '.icon',
                      z $shareIcon,
                        icon: 'share'
                        isTouchTarget: false
                        color: styleConfig.$white
                    z '.text', 'Share with friends'
                  ]
            z 'div.z-drawer-google-play-ad-drawer', $googlePlayAdDrawer
            z "a[href=#{UrlService.getMarketplaceBase()}]
              .z-drawer-marketplace-link",
              onclick: @openMarketplace,
              z 'i.icon.icon-heart'
              z 'span.z-drawer-menu-item', 'Recommended games'
            z 'div.z-drawer-cross-promotion',
              z $crossPromotion, iconSize: GAME_BOX_ICON_SIZE
              z 'button.button-secondary.is-block.z-drawer-browse-more',
                onclick: @openMarketplace,
                'Browse more games'
    ]
