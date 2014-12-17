z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevLoginBanner = require '../../components/dev_login_banner'
DevLogin = require '../../components/dev_login'
DevSignup = require '../../components/dev_signup'
DevLoginPlayerMessage = require '../../components/dev_login_player_message'
DevFooter = require '../../components/dev_footer'
VerticalDivider = require '../../components/vertical_divider'

module.exports = class Login
  constructor: ->
    @state = z.state
      DevHeader: new DevHeader()
      DevLogin: new DevLogin()
      DevLoginBanner: new DevLoginBanner()
      VerticalDivider: new VerticalDivider()
      DevSignup: new DevSignup()
      DevLoginPlayerMessage: new DevLoginPlayerMessage()
      DevFooter: new DevFooter()

  render: =>
    z 'div',
      z 'div', @state().DevHeader
      z 'div', @state().DevLoginBanner
      z 'div.l-content-container.l-flex',
        z 'div', {style: {width: '50%', marginLeft: '-20px'}}, @state().DevLogin
        @state().VerticalDivider
        z 'div.l-flex-right.l-flex-1', {style: marginRight: '-20px'},
          @state().DevSignup
      z 'div', @state().DevLoginPlayerMessage
      z 'div', @state().DevFooter
