z = require 'zorium'

GuestHeader = require '../../components/guest_header'
DevLoginBanner = require '../../components/dev_login_banner'
DevLogin = require '../../components/dev_login'
DevApply = require '../../components/dev_apply'
DevLoginPlayerMessage = require '../../components/dev_login_player_message'
GuestFooter = require '../../components/guest_footer'
VerticalDivider = require '../../components/vertical_divider'

module.exports = class Login
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      devLogin: new DevLogin()
      devLoginBanner: new DevLoginBanner()
      verticalDivider: new VerticalDivider()
      devApply: new DevApply()
      devLoginPlayerMessage: new DevLoginPlayerMessage()
      guestFooter: new GuestFooter()

  render: (
    {
      guestHeader
      devLoginBanner
      devLogin
      verticalDivider
      devApply
      devLoginPlayerMessage
      guestFooter
    }
  ) ->
    z 'div',
      z 'div', guestHeader
      z 'div', devLoginBanner
      z 'div.l-content-container.l-flex', {style: marginBottom: '40px'},
        z 'div', {style: {width: '50%', marginLeft: '-20px'}}, devLogin
        verticalDivider
        z 'div.l-flex-right.l-flex-1', {style: marginRight: '-20px'},
          devApply
      z 'div', devLoginPlayerMessage
      z 'div', guestFooter
