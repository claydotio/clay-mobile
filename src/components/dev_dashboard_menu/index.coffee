z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardMenu
  constructor: ({tab}) ->
    styles.use()

    @state = z.state {tab}

  render: ({tab}) ->
    z '.z-dev-dashboard-menu',
      z '.menu',
        z.router.a '[href=/developers/edit-game/start]',
          z '.text.edit-game', 'Add game'

      z '.menu',
        z.router.a "[href=/developers]
                   #{if not tab or tab is 'games' then '.is-selected' else ''}",
          z '.text', 'My games'
        z.router.a "[href=/developers/dashboard/contact]
                   #{if tab is 'contact' then '.is-selected' else ''}",
          z '.text', 'Contact Us'
