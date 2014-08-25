z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'loglevel'

GameFilter = require '../models/game_filter'
GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir(loadMore: @loadMore)
    @gameBoxes = z.prop []

  loadMore: =>
    GameFilter.getGames
      limit: 10
      skip: @gameBoxes().length
    .then (games) =>
      @gameBoxes @gameBoxes().concat _.map games, (game) ->
        new GameBox(game)

      # force
      z.redraw(true)

    .catch log.error

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
    _.map @gameBoxes(), (gameBox) ->
      z '.game-results-container', [
        z 'div', gameBox.render()
      ]
