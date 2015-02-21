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
ReqProfilePicCard = require '../../components/req_profile_pic_card'
GooglePlayAdService = require '../../services/google_play_ad'
EnvironmentService = require '../../services/environment'

styles = require './index.styl'

module.exports = class GamesPage
  constructor: ->
    styles.use()

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

      newFriends: [{}, {}]

      $friendRequestCard: if 'friendRequest' # FIXME
      then new FriendRequestCard()
      else null

      $reqProfilePicCard: if 'noProfilePic' # FIXME
      then new ReqProfilePicCard()
      else null

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
    {
      $appBar
      $navDrawer
      newFriends
      $friendRequestCard
      $reqProfilePicCard
      $feedbackCard
      $recentGames
      $popularGames
      $modalViewer
    } = @state()

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
          z($friendRequestCard, {newFriends}) or
          $reqProfilePicCard or
          $feedbackCard or
          $googlePlayAdCard
        )
        $recentGames
        $popularGames
    ]
