z = require 'zorium'
_ = require 'lodash'

Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevEditGamePublished
  constructor: ->
    styles.use()

    o_game = Game.getEditingGame()

    @state = z.state
      game: o_game

  render: ({game}) ->
    z 'div.z-dev-edit-game-published',
      z 'i.icon.icon-happy'
      z 'h1', 'Awesome!'
      z 'div.game-published', 'Your game has been published.'
      z 'div.play-now', 'Play it now at ',
        z "a[href=http://#{game?.key}.clay.io]", "#{game?.key}.clay.io"
      z.router.link z 'a[href=/developers].button-secondary.go-to-dashboard',
        'Go to dashboard'
      z 'div',
        z.router.link z "a[href=/developers/edit-game/start/#{game?.id}]
        .edit-game",
          'Edit game listing'
