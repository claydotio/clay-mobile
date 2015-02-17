z = require 'zorium'

LegacyBanner = require '../../components/legacy_banner'
GuestHeader = require '../../components/guest_header'
GuestFooter = require '../../components/guest_footer'
Home = require '../../components/home'

module.exports = class HomePage
  constructor: ->
    @state = z.state
      legacyBanner: new LegacyBanner()
      guestHeader: new GuestHeader()
      home: new Home()
      guestFooter: new GuestFooter()

  render: =>
    {legacyBanner, devHeader, home, guestFooter, guestHeader} = @state()
    z 'div',
      z 'div', legacyBanner
      z 'div', guestHeader
      z 'div', home
      z 'div', guestFooter
