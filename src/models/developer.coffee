localstore = require '../lib/localstore'
request = require '../lib/request'
config = require '../config'

PATH = config.CLAY_API_URL + '/developers'

class Developer
  find: (query) ->
    request PATH,
      qs: query

module.exports = new Developer()
