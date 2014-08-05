z = require 'zorium'
HomePage = new (require './pages/home')()
ActorModel = require './models/actor'
FriendListModel = require './models/friend_list'

if not ActorModel.get()

  # Require user to log in
  ActorModel.login().then null, ActorModel.login

if kik.message
  FriendListModel.add [kik.message.from]

z.route.mode = 'hash'
z.route document.getElementById('app'), '/',
  '/': HomePage
