z = require 'zorium'

User = require '../../models/user'
DevHeader = require '../../components/dev_header'
DevFooter = require '../../components/dev_footer'

module.exports = class Logout
  constructor: ->
    User.logout()
    # hard refresh
    window.location.href = '/developers/login'

    @state = z.state
      DevHeader: new DevHeader()
      DevFooter: new DevFooter()

  render: ->
    z 'div',
      z 'div', @state().DevHeader
      z 'div', {style: textAlign: 'center', margin: '20px'}, 'Logging out...'
      z 'div', @state().DevFooter
