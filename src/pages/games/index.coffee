z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
Header = require '../../components/header'
ModalViewer = require '../../components/modal_viewer'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAdService = require '../../services/google_play_ad'
GooglePlayAd = require '../../components/google_play_ad'

module.exports = class GamesPage
  constructor: ->

    @state = z.state
      header: new Header()
      modalViewer: new ModalViewer()
      recentGames: new RecentGames()
      popularGames: z.observe User.getMe().then( (user) ->
        hasRecentGames = user.links.recentGames
        return if hasRecentGames \
               then new PopularGames({featuredGameRow: 1})
               else new PopularGames({featuredGameRow: 0})
      ).catch log.trace
      googlePlayAd: if GooglePlayAdService.shouldShowAds() \
                    then new GooglePlayAd()
                    else null

    @googlePlayAdModalPromise = GooglePlayAdService.shouldShowAdModal()
    .then (shouldShow) ->
      if shouldShow
        GooglePlayAdService.showAdModal()
    .catch log.trace

  render: ({header, googlePlayAd, recentGames, popularGames, modalViewer}) ->
    z 'div', [
      z 'div', header
      z 'div', googlePlayAd
      z 'div', recentGames
      z 'div', popularGames
      modalViewer
    ]
