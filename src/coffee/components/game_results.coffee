z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

Game = require '../models/game'
GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir(loadMore: @loadMore)

    @gameBoxes = z.prop []

    # TODO Error logs and z.prop Q
    Game.all('games').getTop().then (games) =>
      @gameBoxes _.map games, (game) ->
        new GameBox(url: game.url)

      z.redraw()
    .then null, (e) -> console.log e

  loadMore: =>
    @gameBoxes(@gameBoxes().concat(@gameBoxes()))
    z.redraw()
    Q.when(null)

  render: =>
    z 'section.game-results', {config: @infiniteScrollDir.config},
    _.map @gameBoxes(), (gameBox) ->
      z '.result-container', [
        z '.result', gameBox.render()
      ]
