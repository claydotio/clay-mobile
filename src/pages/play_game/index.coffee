z = require 'zorium'

GamePlayer = require '../../components/game_player'
ModalViewer = require '../../components/modal_viewer'

module.exports = class PlayGamePage
  constructor: ({key} = {}) ->
    gameKey = key
    @GamePlayer = new GamePlayer gameKey: gameKey
    @ModalViewer = new ModalViewer()

  render: =>
    z 'div',
      @GamePlayer
      @ModalViewer
