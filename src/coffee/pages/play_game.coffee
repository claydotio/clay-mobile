z = require 'zorium'

GamePlayer = require '../components/game_player'

module.exports = class PlayGamePage
  constructor: (params) ->
    gameKey = params('key')
    @Header = new (require '../components/header')()
    @gamePlayer = new GamePlayer(gameKey: gameKey)

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @gamePlayer.render()
    ]
