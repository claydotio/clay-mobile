z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'clay-loglevel'

GameFilter = require '../models/game_filter'
GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'
Spinner = require './spinner'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir loadMore: @loadMore
    @gameBoxes = z.prop []

    @Spinner = new Spinner()
    @isLoading = true

  loadMore: =>
    GameFilter.getGames
      limit: 10
      skip: @gameBoxes().length
    .then (games) =>
      @gameBoxes @gameBoxes().concat _.map games, (game) ->
        new GameBox game

      @isLoading = false

      # force
      z.redraw(true)

      # Stop loading more
      if games.length == 0
        return true

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
    (_.map @gameBoxes(), (gameBox) ->
      z '.game-results-box-container', [
        gameBox.render()
      ]
    ).concat [
      if @isLoading then z '.game-results-spinner', @Spinner.render()
    ]
