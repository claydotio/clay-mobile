_ = require 'lodash'
log = require 'loglevel'
ActorModel = require './actor'

class FriendListModel

  # Private
  getSavedFriends = ->
    _.filter(JSON.parse(localStorage.friends or '[]'))

  saveFriends = (friends) ->
    localStorage.friends = JSON.stringify(friends)

  # Public
  clear: ->
    delete localStorage.friends

  get: getSavedFriends

  add: (users) ->
    log.info 'adding', users, 'as', ActorModel.get()
    friends = getSavedFriends()
    saveFriends(
      _.omit(
        _.uniq(
          users.concat(friends),
          'username'
        ),
        (user) -> user.username == ActorModel.get()?.username
      )
    )

  updateSent: (username) ->
    if _.isArray username
      return _.map username, @updateSent

    friends = getSavedFriends()
    _.find(friends, username: username).lastSent = Date.now()
    saveFriends(friends)


module.exports = new FriendListModel()
