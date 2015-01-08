z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardMenu
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-menu',
      z '.menu',
        z.router.a '[href=/developers/edit-game/start]',
          z '.text.edit-game', 'Add game'

      z '.menu',
        z.router.a '.is-selected[href=#]',
          z '.text', 'My games'
        z 'a[href=https://github.com/claydotio/clay-sdk][target=_blank]',
          z '.text', 'Documentation'
