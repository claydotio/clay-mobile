z = require 'zorium'

User = require '../../models/user'
JoinThanksCard = require '../../components/join_thanks_card'
FeedbackCard = require '../../components/feedback_card'
FriendRequestCard = require '../../components/friend_request_card'
RequestAvatarCard = require '../../components/request_avatar_card'
GooglePlayAd = require '../../components/google_play_ad'
GooglePlayAdService = require '../../services/google_play_ad'
EnvironmentService = require '../../services/environment'

module.exports = class HomeCards
  constructor: ->
    @state = z.state
      me: User.getMe()
      isLoggedIn: User.isLoggedIn()
      newFriends: z.observe User.getLocalNewFriends()
      $joinThanksCard: new JoinThanksCard()
      $friendRequestCard: new FriendRequestCard()
      $requestAvatarCard: new RequestAvatarCard()
      $feedbackCard: new FeedbackCard()
      $googlePlayAdCard: new GooglePlayAd()

  render: =>
    {me, isLoggedIn, newFriends, $friendRequestCard,
      $requestAvatarCard, $feedbackCard, $googlePlayAdCard,
      $joinThanksCard} = @state()

    z 'div.z-home-cards',
      if isLoggedIn and not _.isEmpty(newFriends)
        z $friendRequestCard, {friends: newFriends}
      else if isLoggedIn and User.getSignedUpThisSession()
        $joinThanksCard
      else if isLoggedIn and not me.avatarImage
        $requestAvatarCard
      else if GooglePlayAdService.shouldShowAds()
        $googlePlayAdCard
