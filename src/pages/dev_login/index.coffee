z = require 'zorium'

GuestHeader = require '../../components/guest_header'
DevLogin = require '../../components/dev_login'
GuestFooter = require '../../components/guest_footer'

module.exports = class Login
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader(currentPage: 'login')
      devLogin: new DevLogin()
      guestFooter: new GuestFooter()

  render: (
    {
      guestHeader
      devLoginBanner
      devLogin
      devLoginPlayerMessage
      guestFooter
    }
  ) ->
    z 'div',
      z 'div', guestHeader
      z 'div', devLogin
      z 'div', guestFooter
