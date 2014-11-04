Game = require './game'

class GameFilter
  constructor: ->
    @label = 'top'

  # top or new
  setFilter: (label) ->
    @label = label

  getFilter: ->
    @label

  getGames: (params) ->
    if @label is 'new'
      return Game.getNew(params)
    else
      return Game.getTop(params)

module.exports = new GameFilter()
