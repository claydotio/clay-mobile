z = require 'zorium'

HeaderBase = require '../header_base'

# only styles used are from HeaderBase

module.exports = class GuestHeader
  constructor: ({currentPage} = {}) ->
    @state = z.state
      header: new HeaderBase {
        logoUrl: '//cdn.wtf/d/images/logos/logo.svg'
        homeUrl: '/'
        links: [
          {
            text: 'Sign in'
            url: '/developers/login'
            isSelected: currentPage is 'login'
          }
        ]
      }

  render: ({header}) ->
    z '.z-guest-header',
      header
