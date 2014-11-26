z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardMenu
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-menu',
      z '.menu',
        z 'div',
          z '.text.add-game', 'Add game'

      z '.menu',
        z 'div.is-selected',
          z '.text', 'My games'
        z 'div',
          z '.text', 'Documentation'
        z 'div',
          z '.text', 'Account'

      z '.menu',
        z 'div',
          z '.text', 'Exit developer site'
