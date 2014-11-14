z = require 'zorium'
_ = require 'lodash'
Q = require 'q'
log = require 'clay-loglevel'

GameFilter = require '../../models/game_filter'
GameBox = require '../game_box'
InfiniteScrollDir = require '../../directives/infinite_scroll'
Spinner = require '../spinner'

styles = require './index.styl'

LOAD_MORE_GAMES_LIMIT = 10

module.exports = class GameResults
  constructor: ->
    styles.use()

    @infiniteScrollDir = new InfiniteScrollDir loadMore: @loadMore
    @gameBoxes = z.prop []
    @gameBoxSize = 128

    @Spinner = new Spinner()
    @isLoading = true

  loadMore: =>
    @isLoading = true
    z.redraw()

    GameFilter.getGames
      limit: LOAD_MORE_GAMES_LIMIT
      skip: @gameBoxes().length
    .then (games) =>
      @gameBoxes @gameBoxes().concat _.map games, (game) =>
        new GameBox {game, @gameBoxSize}

      @isLoading = false

      # force
      z.redraw(true)

      # Stop loading more
      if _.isEmpty games
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
