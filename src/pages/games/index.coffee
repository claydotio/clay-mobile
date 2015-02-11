z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
AppBar = require '../../components/app_bar'
ModalViewer = require '../../components/modal_viewer'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAd = require '../../components/google_play_ad'
FeedbackCard = require '../../components/feedback_card'
GooglePlayAdService = require '../../services/google_play_ad'
EnvironmentService = require '../../services/environment'

module.exports = class GamesPage
  constructor: ->

    @state = z.state
      $appBar: new AppBar()
      $modalViewer: new ModalViewer()
      $recentGames: new RecentGames()
      $popularGames: z.observe User.getMe().then( (user) ->
        hasRecentGames = user.links.recentGames
        return if hasRecentGames \
               then new PopularGames({featuredGameRow: 1})
               else new PopularGames({featuredGameRow: 0})
      ).catch log.trace
      $topCard: z.observe User.getExperiments().then( ({feedbackCard}) ->
        return if feedbackCard is 'show' and EnvironmentService.isKikEnabled() \
               then new FeedbackCard()
               else if GooglePlayAdService.shouldShowAds() \
               then new GooglePlayAd()
               else null
      ).catch log.trace

    @googlePlayAdModalPromise = GooglePlayAdService.shouldShowAdModal()
    .then (shouldShow) ->
      if shouldShow
        GooglePlayAdService.showAdModal()
        ga? 'send', 'event', 'google_play_ad_modal', 'show', 'clay'
    .catch log.trace

  render: (
    {
      $appBar
      $topCard
      $recentGames
      $popularGames
      $modalViewer
    }) ->
    z 'div', [
      z 'div', $appBar
      z 'div', $topCard
      z 'div', $recentGames
      z 'div', $popularGames
      $modalViewer
    ]
