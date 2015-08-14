z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Tos = require '../../components/tos'

module.exports = class TosPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      tos: new Tos()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, tos, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', tos
      z 'div', guestFooter
