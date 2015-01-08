z = require 'zorium'
log = require 'clay-loglevel'

localstore = require '../../lib/localstore'
User = require '../../models/user'
Modal = require '../../models/modal'
Header = require '../../components/header'
ModalViewer = require '../../components/modal_viewer'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAdService = require '../../services/google_play_ad'
GooglePlayAdControl = require '../../components/google_play_ad'
GooglePlayAdInstallButton =
  require '../../components/google_play_ad/install_button'
GooglePlayAdModalControl = require '../../components/google_play_ad_modal'
GooglePlayAdModalHeaderBackground =
  require '../../components/google_play_ad_modal/header_background'

module.exports = class GamesPage
  constructor: ->
    @Header = new Header()
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
      if params.googlePlayAd isnt 'none' and GooglePlayAdService.shouldShowAds()
        @GooglePlayAd = if params.googlePlayAd is 'install-button' \
                        then new GooglePlayAdInstallButton()
                        else new GooglePlayAdControl()

  showGooglePlayAdModal: ->
    User.getExperiments().then (params) ->
      unless params.googlePlayModal is 'none'
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
      z 'div', @GooglePlayAd
      z 'div', @RecentGames
      z 'div', @PopularGames
      @ModalViewer
    ]
