z = require 'zorium'

config = require '../../config'
HeaderBase = require '../header_base'

module.exports = class GuestHeader
  constructor: ({currentPage} = {}) ->
    @state = z.state
      header: new HeaderBase {
        logoUrl: '//cdn.wtf/d/images/logos/logo.svg'
        homeUrl: "//#{config.HOST}/"
        links: [
          {
            text: 'Sign in'
            url: "https://#{config.DEV_HOST}/login"
            isSelected: currentPage is 'login'
          }
        ]
      }

  render: ({header}) ->
    z '.z-guest-header',
      header
