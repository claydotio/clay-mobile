z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
AppBar = require '../../components/app_bar'
NavDrawer = require '../../components/nav_drawer'
ModalViewer = require '../../components/modal_viewer'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAd = require '../../components/google_play_ad'
FeedbackCard = require '../../components/feedback_card'
FriendRequestCard = require '../../components/friend_request_card'
RequestProfilePicCard = require '../../components/request_profile_pic_card'
GooglePlayAdService = require '../../services/google_play_ad'
EnvironmentService = require '../../services/environment'

styles = require './index.styl'

module.exports = class GamesPage
  constructor: ->
    styles.use()

    o_newFriends = z.observe User.getMe().then ({phone}) ->
      return if phone then User.getLocalNewFriends() else Promise.resolve []

    @state = z.state
      $appBar: new AppBar()
      $navDrawer: new NavDrawer()
      $modalViewer: new ModalViewer()
      $recentGames: new RecentGames()
      $popularGames: z.observe User.getMe().then( (user) ->
        hasRecentGames = user.links.recentGames
        return if hasRecentGames \
               then new PopularGames({featuredGameRow: 1})
               else new PopularGames({featuredGameRow: 0})
      ).catch log.trace

      newFriends: o_newFriends

      $friendRequestCard: z.observe o_newFriends.then( (newFriends) ->
        if not _.isEmpty newFriends
        then new FriendRequestCard()
        else null
      ).catch log.trace

      $requestProfilePicCard: z.observe User.getMe() \
      .then( ({phone, avatarImage}) ->
        if phone and not avatarImage
        then new RequestProfilePicCard()
        else null
      ).catch log.trace

      $feedbackCard: z.observe User.getExperiments().then( ({feedbackCard}) ->
        if feedbackCard is 'show' and EnvironmentService.isKikEnabled()
        then new FeedbackCard()
        else null
      ).catch log.trace

      $googlePlayAdCard: if GooglePlayAdService.shouldShowAds()
      then new GooglePlayAd()
      else null

    @googlePlayAdModalPromise = GooglePlayAdService.shouldShowAdModal()
    .then (shouldShow) ->
      if shouldShow
        GooglePlayAdService.showAdModal()
        ga? 'send', 'event', 'google_play_ad_modal', 'show', 'clay'
    .catch log.trace

  render: =>
    {$appBar, $navDrawer, newFriends, $friendRequestCard, $requestProfilePicCard
      $feedbackCard, $googlePlayAdCard, $recentGames, $popularGames,
      $modalViewer} = @state()

    z 'div.z-games-page', [
      z $appBar, {
        height: '56px'
        topLeftButton: 'menu'
        topRightButton: 'share'
        barType: 'navigation'
      }
      z $navDrawer, {currentPage: 'games'}
      $modalViewer
      z 'div.l-content-container.content',
        (
          if not _.isEmpty newFriends then z($friendRequestCard, {newFriends})
          else $requestProfilePicCard or $feedbackCard or $googlePlayAdCard
        )
        $recentGames
        $popularGames
    ]
