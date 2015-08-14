z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Home = require '../../components/home'

module.exports = class HomePage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      home: new Home()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, home, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', home
      z 'div', guestFooter
