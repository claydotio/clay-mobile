z = require 'zorium'

FriendListView = new (require '../views/friend_list')()
WinkActionView = new (require '../views/wink_action')()

module.exports = class HomePage
  view: ->
    z 'div.c-text-center', [
      WinkActionView.render()
      FriendListView.render()
    ]
  controller: ->
    null
