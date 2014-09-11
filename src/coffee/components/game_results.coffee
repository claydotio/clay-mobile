z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'loglevel'

GameFilter = require '../models/game_filter'
Experiment = require '../models/experiment'
GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'
Spinner = require './spinner'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir loadMore: @loadMore
    @gameBoxes = z.prop []
    @gameBoxTheme = z.prop Experiment.getExperiments().then (params) ->
      switch params.gameBoxColor
        when 'white' then '.theme-background-white'
        else null

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @gameBoxTheme
    .finally z.redraw
    .catch log.trace

    @Spinner = new Spinner()
    @isLoading = true

    z.redraw()

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

    .catch log.error

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
    (_.map @gameBoxes(), (gameBox) =>
      z ".game-results-box-container#{@gameBoxTheme() or ''}", [
        gameBox.render()
      ]
    ).concat [
      if @isLoading then z '.game-results-spinner', @Spinner.render()
    ]
