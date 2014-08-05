z = require 'zorium'
_ = require 'lodash'

WinkService = require '../services/wink'
FriendListModel = require '../models/friend_list'
ActorModel = require '../models/actor'

SENT_TEXT_TIME = 2000

module.exports = class FriendListCtrl
  friendNameText: (friend) ->
    if Date.now() - friend.lastSent < SENT_TEXT_TIME
      setTimeout (-> z.redraw()), SENT_TEXT_TIME
      return 'Sent!'
    friend.username
  winkFriend: (friend) ->
    WinkService.wink ActorModel.get(), friend
    FriendListModel.updateSent friend.username
  getFriends: ->
    _.map FriendListModel.get(), (friend) ->
      username: friend.username
      lastSent: friend.lastSent or ''
  addFriends: ->
    z.startComputation()
    friended = _.pluck(FriendListModel.get(), 'username')
    kik.pickUsers filtered: friended, (users) ->
      if not users
        z.endComputation()
        return
      FriendListModel.add users
      z.endComputation()
