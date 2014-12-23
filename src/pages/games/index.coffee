z = require 'zorium'
log = require 'clay-loglevel'

localstore = require '../../lib/localstore'
User = require '../../models/user'
Modal = require '../../models/modal'
GooglePlayAdService = require '../../services/google_play_ad'
Header = require '../../components/header'
ModalViewer = require '../../components/modal_viewer'
GooglePlayAdControl = require '../../components/google_play_ad'
GooglePlayAdInstallButton =
  require '../../components/google_play_ad/install_button'
GooglePlayAdModalControl = require '../../components/google_play_ad_modal'
GooglePlayAdModalHeaderBackground =
  require '../../components/google_play_ad_modal/header_background'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'

module.exports = class GamesPage
  constructor: ->
    @Header = new Header()
    @GooglePlayAd = new GooglePlayAd()
    @ModalViewer = new ModalViewer()
    @PopularGames = null
    @RecentGames = new RecentGames()

    @PopularGames = null
    User.getMe().then (user) =>
      hasRecentGames = user.links.recentGames
      if hasRecentGames
        @PopularGames = new PopularGames({featuredGameRow: 1})
      else
        @PopularGames = new PopularGames({featuredGameRow: 0})

      z.redraw()
    .catch log.trace

    User.getExperiments().then (params) =>
      GooglePlayAdComponent = if params.googlePlayAd is 'install-button' \
                              then new GooglePlayAdInstallButton()
                              else new GooglePlayAdControl()

      @GooglePlayAd = if GooglePlayAdService.shouldShowAds() \
                      then GooglePlayAdComponent
                      else null

  showGooglePlayAdModal: ->
    User.getExperiments().then (params) ->
      GooglePlayAdModalComponent =
                            if params.googlePlayModal is 'header-background' \
                            then new GooglePlayAdModalHeaderBackground()
                            else new GooglePlayAdModalControl()
      Modal.openComponent(
        component: GooglePlayAdModalComponent
      )

      localstore.set 'hasSeenGooglePlayAd', seen: true

  onMount: =>
    if GooglePlayAdService.shouldShowAds()
      localstore.get('hasSeenGooglePlayAd').then (hasSeenAd) =>
        unless hasSeenAd
          @showGooglePlayAdModal()

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @RecentGames
      z 'div', @PopularGames
      @ModalViewer
    ]
