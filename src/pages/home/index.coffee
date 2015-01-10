z = require 'zorium'

DevBanner = require '../../components/dev_banner'
GuestHeader = require '../../components/guest_header'
DevFooter = require '../../components/dev_footer'
Home = require '../../components/home'

module.exports = class HomePage
  constructor: ->
    @state = z.state
      devBanner: new DevBanner()
      guestHeader: new GuestHeader()
      home: new Home()
      devFooter: new DevFooter()

  render: ({devBanner, devHeader, home, devFooter, guestHeader}) ->
    z 'div',
      z 'div', devBanner
      z 'div', guestHeader
      z 'div', home
      z 'div', devFooter
