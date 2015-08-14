z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
About = require '../../components/about'

module.exports = class ContactPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      about: new About()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, about, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', about
      z 'div', guestFooter
