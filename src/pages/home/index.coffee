z = require 'zorium'

DevBanner = require '../../components/dev_banner'
DevHeader = require '../../components/dev_header'
DevFooter = require '../../components/dev_footer'
Home = require '../../components/home'

module.exports = class HomePage
  constructor: ->
    @state = z.state
      devBanner: new DevBanner()
      devHeader: new DevHeader()
      home: new Home()
      devFooter: new DevFooter()

  render: ({devBanner, devHeader, home, devFooter}) ->
    z 'div',
      z 'div', devBanner
      z 'div', devHeader
      z 'div', home
      z 'div', devFooter
