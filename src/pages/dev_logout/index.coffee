z = require 'zorium'

User = require '../../models/user'
GuestHeader = require '../../components/guest_header'

module.exports = class Logout
  constructor: ->
    User.logout()
    # hard refresh
    window.location.href = '/developers/login'

    @state = z.state
      guestHeader: new GuestHeader()

  render: ({guestHeader}) ->
    z 'div',
      z 'div', guestHeader
      z 'div', {style: textAlign: 'center', margin: '20px'}, 'Logging out...'
