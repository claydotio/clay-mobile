Game = require './game'

class GameFilter
  constructor: ->
    @label = 'top'

  setFilter: (label) ->
    @label = label

  getFilter: ->
    @label

  getGames: (params) ->
    if @label == 'new'
      return Game.all('games').getNew(params)
    else
      return Game.all('games').getTop(params)

module.exports = new GameFilter()
