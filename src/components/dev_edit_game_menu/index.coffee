z = require 'zorium'

Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevEditGameMenu
  constructor: ({step}) ->
    styles.use()

    @state = z.state {step, gameId: null}

  onMount: =>
    Game.getEditingGame().then (game) =>
      @state.set gameId: game.id

  render: =>
    z '.z-dev-edit-game-menu',
      z '.menu',
        z.router.a '[href=/developers]',
          z 'div.text', 'Back to dashboard'

      z '.menu',
        z.router.a "[href=/developers/edit-game/start/#{@state().gameId}]
          #{if @state().step is 'start' then '.is-selected' else ''}",
          z 'div.l-flex.l-vertical-center',
            z 'div.text', 'Get started'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/edit-game/details/#{@state().gameId}]
          #{if @state().step is 'details' then '.is-selected' else ''}",
          z 'div.l-flex.l-vertical-center',
            z 'div.text', 'Add details'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/edit-game/upload/#{@state().gameId}]
          #{if @state().step is 'upload' then '.is-selected' else ''}",
          z 'div.l-flex.l-vertical-center',
            z 'div.text', 'Upload game'
            z 'i.icon.icon-check'


      z '.menu',
        z.router.a '[href=/developers/edit-game/published].publish',
          z 'div.text', 'Publish'
