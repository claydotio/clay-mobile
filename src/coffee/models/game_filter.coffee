Game = require './game'

class GameFilter
  constructor: ->
    @label = 'top'

  setFilter: (label) ->
    @label = label

  getFilter: ->
    @label

  getGames: ->
    if @label == 'new'
      return Game.all('games').getNew()
    else
      return Game.all('games').getTop()

module.exports = new GameFilter()
