z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
DevInfo = require '../../components/dev_info'

module.exports = class TosPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      devInfo: new DevInfo()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, devInfo, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', devInfo
      z 'div', guestFooter
