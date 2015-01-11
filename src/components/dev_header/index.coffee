z = require 'zorium'

HeaderBase = require '../header_base'

styles = require './index.styl'

module.exports = class DevHeader
  constructor: ({currentPage} = {}) ->
    styles.use()

    @state = z.state
      header: new HeaderBase {
        logoUrl: '//cdn.wtf/d/images/logos/logo_dev.svg'
        homeUrl: '/developers'
        links: [
          {
            text: 'Dashboard'
            url: '/developers'
            isSelected: currentPage is 'dashboard'
          }
          {
            text: 'Dev Docs'
            url: 'https://github.com/claydotio/clay-sdk'
            isExternal: true
          }
          {
            text: 'Logout'
            url: '/developers/logout'
          }
        ]
      }

  render: ({header}) ->
    z '.z-dev-header',
      header
