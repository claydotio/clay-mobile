z = require 'zorium'

Header = require '../../components/header/orange_shadow'
RecentGames = require '../../components/recent_games/list'
GooglePlayAd = require '../../components/google_play_ad'
GameResults = require '../../components/game_results/popular_small_top'
ModalViewer = require '../../components/modal_viewer'

module.exports = class GamesPage
  constructor: ->
    @Header = new Header()
    @GooglePlayAd = new GooglePlayAd()
    @RecentGames = new RecentGames()
    @PopularGames = new GameResults()
    @ModalViewer = new ModalViewer()

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @GooglePlayAd
      z 'div', @RecentGames
      z 'div', @PopularGames
      @ModalViewer
    ]
