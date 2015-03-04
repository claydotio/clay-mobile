z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
AppBar = require '../../components/app_bar'
MenuButton = require '../../components/menu_button'
MarketplaceShareButton = require '../../components/marketplace_share_button'
NavDrawer = require '../../components/nav_drawer'
ModalViewer = require '../../components/modal_viewer'
HomeCards = require '../../components/home_cards'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAdService = require '../../services/google_play_ad'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GamesPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $menuButton: new MenuButton()
      $marketplaceShare: new MarketplaceShareButton()
      $navDrawer: new NavDrawer()
      $modalViewer: new ModalViewer()
      $homeCards: new HomeCards()
      $recentGames: new RecentGames()
      $popularGames: z.observe User.getMe().then( (user) ->
        hasRecentGames = user.links.recentGames
        return if hasRecentGames \
               then new PopularGames({featuredGameRow: 1})
               else new PopularGames({featuredGameRow: 0})
      ).catch log.trace


    @googlePlayAdModalPromise = GooglePlayAdService.shouldShowAdModal()
    .then (shouldShow) ->
      if shouldShow
        GooglePlayAdService.showAdModal()
        ga? 'send', 'event', 'google_play_ad_modal', 'show', 'clay'
    .catch log.trace

  render: =>
    {$appBar, $navDrawer, $homeCards, $menuButton, $marketplaceShare,
      $recentGames, $popularGames, $modalViewer} = @state()

    z 'div.z-games-page', [
      z $appBar, {
        height: "#{styleConfig.$appBarHeightShort}px"
        $topLeftButton: z $menuButton, {isAlignedLeft: true}
        $topRightButton: z $marketplaceShare, {isAlignedRight: true}
      }
      z $navDrawer, {currentPage: 'games'}
      $modalViewer
      z 'div.l-content-container.content',
        $homeCards
        $recentGames
        $popularGames
    ]
