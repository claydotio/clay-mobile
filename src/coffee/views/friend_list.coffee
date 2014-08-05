z = require 'zorium'
FriendListCtrl = new (require '../controllers/friend_list')()
styleVars = require '../../stylus/vars'

module.exports = class FriendListView
  render: ->
    friendBgIndex = 0
    [
      FriendListCtrl.getFriends().map (friend) ->
        colors = styleVars.friendColors
        friendBgIndex += 1
        z 'div.friend-button', (
            style:
              backgroundColor: colors[friendBgIndex % colors.length]
            onclick: ->
              FriendListCtrl.winkFriend friend
          ), FriendListCtrl.friendNameText friend
      z 'a.add-friend-button',
        onclick: FriendListCtrl.addFriends,
        '+ Add Friend'
    ]
