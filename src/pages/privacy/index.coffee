z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Privacy = require '../../components/privacy'

module.exports = class TosPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      privacy: new Privacy()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, privacy, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', privacy
      z 'div', guestFooter
