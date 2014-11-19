z = require 'zorium'

localstore = require '../../lib/localstore'
GameFilter = require '../../models/game_filter'
User = require '../../models/user'
Modal = require '../../models/modal'
GooglePlayAdService = require '../../services/google_play_ad'
Header = require '../../components/header'
GameMenu = require '../../components/game_menu'
GameResults = require '../../components/game_results'
ModalViewer = require '../../components/modal_viewer'
GooglePlayAdControl = require '../../components/google_play_ad'
GooglePlayAdInstallButton =
  require '../../components/google_play_ad/install_button'
GooglePlayAdModalControl = require '../../components/google_play_ad_modal'
GooglePlayAdModalHeaderBackground =
  require '../../components/google_play_ad_modal/header_background'

module.exports = class GamesPage
  constructor: ({filter} = {}) ->
    GameFilter.setFilter filter or 'top'

    @Header = new Header()
    @GameMenu = new GameMenu()
    @GooglePlayAd = new GooglePlayAd()
    @GameResults = new GameResults()
    @ModalViewer = new ModalViewer()


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
      z 'div', @GameMenu
      z 'div', @GooglePlayAd
      z 'div', @GameResults
      @ModalViewer
    ]
