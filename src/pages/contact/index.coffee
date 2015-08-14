z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Contact = require '../../components/contact'

module.exports = class ContactPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      contact: new Contact()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, contact, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div.l-content-container', contact
      z 'div', guestFooter
