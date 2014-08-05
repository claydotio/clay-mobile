z = require 'zorium'
_ = require 'lodash'

WinkService = require '../services/wink'
FriendListModel = require '../models/friend_list'
ActorModel = require '../models/actor'

module.exports = class WinkCtrl
  pickAndWink: ->
    z.startComputation()
    kik.pickUsers (users) ->
      if not users
        z.endComputation()
        return

      FriendListModel.add users
      WinkService.wink ActorModel.get(), users
      FriendListModel.updateSent _.pluck(users, 'username')
      z.endComputation()
