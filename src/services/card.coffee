User = require '../models/user'
GooglePlayAdService = require '../services/google_play_ad'
EnvironmentService = require '../services/environment'
localstore = require '../lib/localstore'
config = require '../config'

class CardService
  shouldShowFriendRequestCard: ->
    User.getMe().then ({phone}) ->
      return if phone then User.getLocalNewFriends() else Promise.resolve []
    .then (newFriends) ->
      return not _.isEmpty newFriends

  shouldShowJoinThanksCard: ->
    User.getMe().then ({phone}) ->
      unless phone
        return false

      localstore.get config.LOCALSTORE_SHOW_THANKS
      .then (showThanks) ->
        if showThanks
          localstore.del config.LOCALSTORE_SHOW_THANKS
          return true
        else
          return false

  shouldShowRequestAvatarCard: ->
    User.getMe().then ({phone, avatarImage}) ->
      return Boolean phone and not avatarImage

  shouldShowFeedbackCard: ->
    User.getExperiments().then ({feedbackCard}) ->
      return feedbackCard is 'show' and EnvironmentService.isKikEnabled()

  shouldShowGooglePlayCard: ->
    Promise.resolve GooglePlayAdService.shouldShowAds()

module.exports = new CardService()
