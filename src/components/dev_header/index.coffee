z = require 'zorium'

styles = require './index.styl'

module.exports = class DevDashboardHeader
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-header',
      z '.l-content-container.l-flex.l-vertical-center',
        z.router.a '.logo[href=/developers]',
          z 'img[src=//cdn.wtf/d/images/logos/logo_dev.svg]'
        z 'nav.navigation',
          z 'ul',
            z 'li.is-selected',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=/developers]', 'Dashboard'
            z 'li',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=/developers/logout]', 'Sign out'
