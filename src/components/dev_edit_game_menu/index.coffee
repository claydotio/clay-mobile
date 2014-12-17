z = require 'zorium'

styles = require './index.styl'

module.exports = class DevAddGameMenu
  constructor: ({step, gameId}) ->
    styles.use()

    @state = z.state {step, gameId}

  render: =>
    z '.z-dev-edit-game-menu',
      z '.menu',
        z.router.a '[href=/developers]',
          z 'div.text', 'Back to dashboard'

      z '.menu',
        z.router.a "[href=/developers/edit-game/#{@state().gameId}]
          #{if not @state().step then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Get started'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/edit-game/details/#{@state().gameId}]
          #{if @state().step is 'details' then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Add details'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/edit-game/upload/#{@state().gameId}]
          #{if @state().step is 'upload' then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Upload game'
            z 'i.icon.icon-check'
