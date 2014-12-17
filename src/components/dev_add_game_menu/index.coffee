z = require 'zorium'

styles = require './index.styl'

module.exports = class DevAddGameMenu
  constructor: ({step}) ->
    styles.use()

    @state = z.state {step}

  render: =>
    z '.z-dev-add-game-menu',
      z '.menu',
        z.router.a '[href=/developers]',
          z 'div.text', 'Back to dashboard'

      z '.menu',
        z.router.a "[href=/developers/add-game]
          #{if not @state().step then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Get started'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/add-game/details]
          #{if @state().step is 'details' then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Add details'
            z 'i.icon.icon-check'
        z.router.a "[href=/developers/add-game/upload]
          #{if @state().step is 'upload' then '.is-selected' else ''}",
          z 'div.l-flex.is-vertical-center',
            z 'div.text', 'Upload game'
            z 'i.icon.icon-check'

      z '.menu',
        z.router.a '[href=/developers/add-game/published].publish',
          z 'div.text', 'Publish'
