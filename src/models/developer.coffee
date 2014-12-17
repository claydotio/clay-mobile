localstore = require '../lib/localstore'
config = require '../config'

Game = require './game'
request = require '../lib/request'

PATH = config.CLAY_API_URL + '/developers'

class Developer
  find: (query) ->
    request PATH,
      qs: query

  getGames: (developerId) ->
    Game.find {developerId}

module.exports = new Developer()
