localstore = require '../lib/localstore'
request = require '../lib/request'
config = require '../config'
User = require './user'

PATH = config.CLAY_API_URL + '/developers'

class Developer
  find: (query) ->
    request PATH,
      qs: query

  create: ->
    User.getMe().then ({accessToken}) ->
      request PATH,
        method: 'POST'
        qs: {accessToken}
        body: {}

module.exports = new Developer()
