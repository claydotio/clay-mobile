z = require 'zorium'
_ = require 'lodash'

Game = require '../../models/game'
UrlService = require '../../services/url'

styles = require './index.styl'

module.exports = class DevEditGamePublished
  constructor: ->
    styles.use()

    o_game = Game.getEditingGame()

    @state = z.state
      game: o_game

  render: =>
    {game} = @state()

    gameUrl = UrlService.getGameSubdomain {game}
    z 'div.z-dev-edit-game-published',
      z 'i.icon.icon-happy'
      z 'h1', 'Awesome!'
      z 'div.game-published', 'Your game has been published.'
      z 'div.play-now', 'Play it now at ',
        z "a[href=#{gameUrl}]", "#{gameUrl}"
      z.router.link z 'a[href=/dashboard].button-secondary.go-to-dashboard',
        'Go to dashboard'
      z 'div',
        z.router.link z "a[href=/edit-game/start/#{game?.id}]
        .edit-game",
          'Edit game listing'
