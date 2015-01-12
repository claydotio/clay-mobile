z = require 'zorium'
_ = require 'lodash'

Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevEditGamePublished
  constructor: ->
    styles.use()

    @state = z.state
      gameKey: ''
      gameId: null

    Game.getEditingGame().then (game) =>
      @state.set
        gameKey: game.key
        gameId: game.id

  render: ({gameKey, gameId}) ->
    z 'div.z-dev-edit-game-published',
      z 'i.icon.icon-happy'
      z 'h1', 'Awesome!'
      z 'div.game-published', 'Your game has been published.'
      z 'div.play-now', 'Play it now at ',
        z "a[href=http://#{gameKey}.clay.io]", "#{gameKey}.clay.io"
      z.router.link z 'a[href=/developers].button-secondary.go-to-dashboard',
        'Go to dashboard'
      z 'div',
        z.router.link z "a[href=/developers/edit-game/start/#{gameId}]
        .edit-game",
          'Edit game listing'
