z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardHeader
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-header',
      z '.l-content-container.l-flex',
        z '.logo',
          z 'img[src=//cdn.wtf/d/images/logos/logo.svg]'
          z 'span.title', 'developers'

        z '.user',
          z '.name', 'Ironhide Games'
          z 'img[src=//lorempixel.com/50/50/abstract]'
