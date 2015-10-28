z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardMenu
  constructor: ({selected}) ->
    styles.use()

    selected ?= 'games'

    @state = z.state {selected}

  render: =>
    {selected} = @state()

    z '.z-dev-dashboard-menu',
      # TODO: re-enable once we're ready to accept more games
      # z '.menu',
      #   z.router.link z 'a[href=/edit-game/start]',
      #     z '.text.add-game', 'Add game'

      z '.menu',
        z.router.link z "a[href=/dashboard/games]
                   #{if selected is 'games' then '.is-selected' else ''}",
          z '.text', 'My games'
        z.router.link z "a[href=/dashboard/contact]
                   #{if selected is 'contact' then '.is-selected' else ''}",
          z '.text', 'Contact Us'

      'New submissions are currently disabled'
      z.router.link z 'a[href=/edit-game/start]',
        '.'
