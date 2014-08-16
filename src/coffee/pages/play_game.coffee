z = require 'zorium'

GamePlayer = require '../components/game_player'

module.exports = class PlayGamePage
  constructor: (params) ->
    gameKey = params('key')
    @gameHeader = new (require '../components/game_header')()
    @gamePlayer = new GamePlayer(gameKey: gameKey)

  render: =>
    z 'div', [
      z 'div', @gamePlayer.render()
      z 'div', @gameHeader.render()
    ]
