should = require('clay-chai').should()

FriendListModel = require 'models/friend_list'

describe 'FriendListModel', ->
  beforeEach FriendListModel.clear

  it 'add()', ->
    FriendListModel.add [{username: 'jim'}, {username: 'bob'}]

  it 'get()', ->
    FriendListModel.add [{username: 'jim'}, {username: 'bob'}]
    friends = FriendListModel.get()
    friends.length.should.be 2
    friends[0].username.should.be 'jim'

  it 'updateSent()', ->
    FriendListModel.add [{username: 'jim'}]
    should.not.exist FriendListModel.get()[0].lastSent
    FriendListModel.updateSent ['jim']
    FriendListModel.get()[0].lastSent.should.to.be.at.most Date.now()
