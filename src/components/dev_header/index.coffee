z = require 'zorium'

HeaderBase = require '../header_base'
User = require '../../models/user'

# only styles used are from HeaderBase

module.exports = class DevHeader
  constructor: ({currentPage} = {}) ->
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
            url: '/developers/login'
            isExternal: true
            onclick: (e) ->
              e.preventDefault()
              User.logout()
              z.router.go '/developers/login'
          }
        ]
      }

  render: ({header}) ->
    z '.z-dev-header',
      header
