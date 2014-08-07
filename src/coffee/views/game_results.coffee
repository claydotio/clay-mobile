z = require 'zorium'
_ = require 'lodash'
Q = require 'q'

GameBox = require './game_box'
GamesCtrl = new (require '../controllers/games')()
InfiniteScrollCtrl = require '../controllers/infinite_scroll'

module.exports = class GameResultsView
  constructor: ->
    @infiniteScrollCtrl = new InfiniteScrollCtrl(loadMore: @loadMore)
    @gameBoxes = _.map GamesCtrl.getTop(15), (game) ->
      new GameBox(url: game.url)

  loadMore: =>
    @gameBoxes = @gameBoxes.concat(@gameBoxes)
    z.redraw()
    Q.when(null)

  render: ->
    z 'section.game-results', {config: @infiniteScrollCtrl.config},
    _.map @gameBoxes, (gameBox) ->
      z '.result-container', [
        z '.result', gameBox.render()
      ]
