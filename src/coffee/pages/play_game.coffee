z = require 'zorium'

GamePlayer = require '../components/game_player'
ModalViewer = require '../components/modal_viewer'
UrlService = require '../services/url'

module.exports = class PlayGamePage
  constructor: (params) ->
    gameKey = params 'key'
    @GamePlayer = new GamePlayer gameKey: gameKey
    @ModalViewer = new ModalViewer()

    # FIXME: this should be implemented at zorium-level
    # don't send for direct hits to game since GA already does
    # WARNING: this doesn't set the proper title
    if UrlService.isRootPath()
      ga? 'send', 'pageview', "/#{gameKey}"

  render: =>
    z 'div',
      @GamePlayer.render()
      @ModalViewer.render()
