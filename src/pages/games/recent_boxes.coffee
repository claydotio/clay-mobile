z = require 'zorium'

User = require '../../models/user'
Header = require '../../components/header/orange_shadow'
RecentGames = require '../../components/recent_games'
GooglePlayAdControl = require '../../components/google_play_ad'
GooglePlayAdInstallButton =
  require '../../components/google_play_ad/install_button'
GameResults = require '../../components/game_results/popular'
ModalViewer = require '../../components/modal_viewer'

module.exports = class GamesPage
  constructor: ->

    @Header = new Header()
    @RecentGames = new RecentGames()
    @PopularGames = new GameResults()
    @ModalViewer = new ModalViewer()

    @GooglePlayAd = null
    User.getMe().then (user) =>
      User.getExperiments().then (params) =>
        @GooglePlayAd = if params.googlePlayHome is 'control' \
                              then new GooglePlayAdInstallButton()
                              else new GooglePlayAdControl()
      .then z.redraw

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @GooglePlayAd
      z 'div', @RecentGames
      z 'div', @PopularGames
      @ModalViewer
    ]
