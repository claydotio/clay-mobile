z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'loglevel'

Game = require '../models/game'
GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir(loadMore: @loadMore)

    @gameBoxes = z.prop []

  loadMore: =>
    Game.all('games').getTop().then (games) =>
      @gameBoxes @gameBoxes().concat _.map games, (game) ->
        new GameBox(url: game.url)
      z.redraw()
    .catch log.error

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
    _.map @gameBoxes(), (gameBox) ->
      z '.result-container', [
        z '.result', gameBox.render()
      ]
