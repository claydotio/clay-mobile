z = require 'zorium'

AppBar = require '../../components/app_bar'
NavDrawer = require '../../components/nav_drawer'
Friends = require '../../components/friends'

styles = require './index.styl'

module.exports = class FriendsPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $navDrawer: new NavDrawer()
      $friends: new Friends()

  render: =>
    {
      $appBar
      $navDrawer
      $friends
    } = @state()

    z 'div.z-friends-page', [
      z $appBar, {
        height: '56px'
        topLeftButton: 'menu'
        topRightButton: 'share'
        barType: 'navigation'
        title: 'Friends'
      }
      z 'div', $navDrawer
      z 'div.l-content-container.content', $friends
    ]
