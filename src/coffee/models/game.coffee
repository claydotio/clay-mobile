resource = require '../lib/resource'
config = require '../config'

resource.extendCollection 'games', (collection) ->
  collection.getTop = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    @customGETLIST('top', {limit: limit, skip: skip})

  collection.getNew = ({limit, skip}) ->
    skip ?= 0
    limit ?= 10
    @customGETLIST('new', {limit: limit, skip: skip})

  collection.findOne = (query) ->
    @customGET('findOne', query)

  return collection

resource.extendModel 'games', (model) ->
  model.getSubdomainUrl = ->
    '//' + model.key + '.' + window.location.host

  model.getRoute = ->
    '/game/' + model.key

  return model

module.exports = resource.setBaseUrl config.API_PATH
