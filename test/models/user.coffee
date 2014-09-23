should = require('clay-chai').should()

User = require 'models/user'

# describe.only 'UserModel', ->
#   it 'returns cached local user', ->
#     User.all('users').setMe {id: 123, username: 'tester'}
#     .then (user) ->
#       user.id.should.be 123
#       user.username.should.be 'tester'
#
#       User.all('users').getMe()
#       .then (sameUser) ->
#         sameUser.should.be user
