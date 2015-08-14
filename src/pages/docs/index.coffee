z = require 'zorium'

GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Docs = require '../../components/docs'

module.exports = class ContactPage
  constructor: ->
    @state = z.state
      guestHeader: new GuestHeader()
      docs: new Docs()
      guestFooter: new GuestFooter()

  render: =>
    {devHeader, docs, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', guestHeader
      z 'div', docs
      z 'div', guestFooter
