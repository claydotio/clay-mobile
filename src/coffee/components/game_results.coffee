z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

GameBox = require './game_box'
InfiniteScrollDir = require '../directives/infinite_scroll'

module.exports = class GameResults
  constructor: ->
    @infiniteScrollDir = new InfiniteScrollDir(loadMore: @loadMore)

    stub = [{url: 'http://slime.clay.io/claymedia/icon128.png'}]
    @gameBoxes = _.map stub, (game) ->
      new GameBox(url: game.url)

  loadMore: =>
    @gameBoxes = @gameBoxes.concat(@gameBoxes)
    z.redraw()
    Q.when(null)

  render: ->
    z 'section.game-results', {config: @infiniteScrollDir.config},
    _.map @gameBoxes, (gameBox) ->
      z '.result-container', [
        z '.result', gameBox.render()
      ]
