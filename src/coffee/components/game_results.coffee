z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'loglevel'

GameFilter = require '../models/game_filter'
GameBox = require './game_box'
Experiment = require '../models/experiment'
InfiniteScrollDir = require '../directives/infinite_scroll'


module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir(loadMore: @loadMore)
    @gameBoxes = z.prop []
    @gameBoxTheme = z.prop null
    @Spinner = new (require './spinner')()
    @isLoading = true

    Experiment.getExperiments().then (params) =>
      @gameBoxTheme = z.prop switch params.gameBoxColor
        when 'white' then '.theme-background-white'
        else  null
      z.redraw()
    .catch log.error

  loadMore: =>
    @isLoading = true
    z.redraw()

    GameFilter.getGames
      limit: 10
      skip: @gameBoxes().length
    .then (games) =>
      @gameBoxes @gameBoxes().concat _.map games, (game) ->
        new GameBox(game)

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
