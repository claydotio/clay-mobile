z = require 'zorium'

GamePlayer = require '../components/game_player'
ModalViewer = require '../components/modal_viewer'

module.exports = class PlayGamePage
  constructor: (params) ->
    gameKey = params 'key'
    @GamePlayer = new GamePlayer gameKey: gameKey
    @ModalViewer = new ModalViewer()

  render: =>
    z 'div',
      @GamePlayer.render()
      @ModalViewer.render()
