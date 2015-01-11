z = require 'zorium'

HeaderBase = require '../header_base'

styles = require './index.styl'

module.exports = class GuestHeader
  constructor: ({currentPage} = {}) ->
    styles.use()

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
