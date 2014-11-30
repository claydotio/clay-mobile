z = require 'zorium'

localstore = require '../../lib/localstore'
User = require '../../models/user'
Modal = require '../../models/modal'
FeaturesService = require '../../services/features'
Header = require '../../components/header'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
ModalViewer = require '../../components/modal_viewer'
GooglePlayAd = require '../../components/google_play_ad'
GooglePlayAdModalControl = require '../../components/google_play_ad_modal'
GooglePlayAdModalHeaderBackground =
  require '../../components/google_play_ad_modal/header_background'
User = require '../../models/user'

module.exports = class GamesPage
  constructor: ->
    @Header = new Header()
    @ModalViewer = new ModalViewer()
    @RecentGames = new RecentGames()

    @PopularGames = null
    User.getMe().then (user) =>
      hasRecentGames = user.links.recentGames
      if hasRecentGames
        @PopularGames = new PopularGames({featuredGameRow: 1})
      else
        @PopularGames = new PopularGames({featuredGameRow: 0})

      z.redraw()

    FeaturesService.shouldShowGooglePlayAds().then (shouldShow) =>
      @GooglePlayAd = if shouldShow then new GooglePlayAd() else null

  showGooglePlayAdModal: ->
    User.getMe().then (user) ->
      User.getExperiments().then (params) ->
        GooglePlayAdModalComponent = if params.googlePlayModal is 'control' \
                              then new GooglePlayAdModalHeaderBackground()
                              else new GooglePlayAdModalControl()
        Modal.openComponent(
          component: GooglePlayAdModalComponent
        )

        localstore.set 'hasSeenGooglePlayAd', seen: true

  onMount: =>
    FeaturesService.shouldShowGooglePlayAds().then (shouldShow) =>
      if shouldShow
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
