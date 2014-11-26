z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardMenu
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-menu',
      z '.menu',
        z 'div',
          z '.text', 'Back to dashboard'

      z '.menu',
        z 'div.is-selected',
          z '.text', 'Get started'
        z 'div',
          z '.text', 'Add details'
        z 'div',
          z '.text', 'Upload game'

      z '.menu',
        z 'div',
          z '.text', 'Publish'
