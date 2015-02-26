z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
AppBar = require '../../components/app_bar'
NavDrawer = require '../../components/nav_drawer'
ModalViewer = require '../../components/modal_viewer'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
GooglePlayAd = require '../../components/google_play_ad'
JoinThanksCard = require '../../components/join_thanks_card'
FeedbackCard = require '../../components/feedback_card'
FriendRequestCard = require '../../components/friend_request_card'
RequestAvatar = require '../../components/request_avatar_card'
GooglePlayAdService = require '../../services/google_play_ad'
CardService = require '../../services/card'

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

      $joinThanksCard: z.observe CardService.shouldShowJoinThanksCard() \
      .then( (shouldShow) ->
        console.log shouldShow
        if shouldShow then new JoinThanksCard() else null
      ).catch log.trace

      $friendRequestCard: z.observe CardService.shouldShowFriendRequestCard() \
      .then( (shouldShow) ->
        if shouldShow then new FriendRequestCard() else null
      ).catch log.trace

      $requestAvatar: z.observe CardService.shouldShowRequestAvatarCard() \
      .then( (shouldShow) ->
        if shouldShow then new RequestAvatar() else null
      ).catch log.trace

      $feedbackCard: z.observe CardService.shouldShowFeedbackCard() \
      .then( (shouldShow) ->
        if shouldShow then new FeedbackCard() else null
      ).catch log.trace

      $googlePlayAdCard: z.observe CardService.shouldShowGooglePlayCard() \
      .then( (shouldShow) ->
        if shouldShow then new GooglePlayAd() else null
      ).catch log.trace

    @googlePlayAdModalPromise = GooglePlayAdService.shouldShowAdModal()
    .then (shouldShow) ->
      if shouldShow
        GooglePlayAdService.showAdModal()
        ga? 'send', 'event', 'google_play_ad_modal', 'show', 'clay'
    .catch log.trace

  render: =>
    {$appBar, $navDrawer, newFriends, $friendRequestCard, $requestAvatar
      $feedbackCard, $googlePlayAdCard, $joinThanksCard, $recentGames,
      $popularGames,$modalViewer} = @state()

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
          if $friendRequestCard then z($friendRequestCard, {newFriends})
          else $joinThanksCard or $requestAvatar or
                $feedbackCard or $googlePlayAdCard
        )
        $recentGames
        $popularGames
    ]
