z = require 'zorium'

GuestHeader = require '../../components/guest_header'
DevLogin = require '../../components/dev_login'
GuestFooter = require '../../components/guest_footer'

module.exports = class Login
  constructor: ->
    @state = z.state
      $guestHeader: new GuestHeader()
      $devLogin: new DevLogin()
      $guestFooter: new GuestFooter()

  render: =>
    {
      $guestHeader
      $devLogin
      $guestFooter
    } = @state()

    z 'div',
      z 'div',
        z $guestHeader, currentPage: 'login'
      z 'div', $devLogin
      z 'div', $guestFooter
