should = require('clay-chai').should()

FriendListCtrl = new (require 'controllers/friend_list')()

describe 'FriendListCtrl', ->
  it 'gets friendNameText', ->
    name = FriendListCtrl.friendNameText {username: 'jim', lastSent: Date.now()}
    name.should.be 'Sent!'

    past = Date.now() - 10000
    name = FriendListCtrl.friendNameText {username: 'jim', lastSent: past}
    name.should.be 'jim'
