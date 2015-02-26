z = require 'zorium'

AppBar = require '../../components/app_bar'
MenuButton = require '../../components/menu_button'
NavDrawer = require '../../components/nav_drawer'
Friends = require '../../components/friends'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class FriendsPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $menuButton: new MenuButton()
      $navDrawer: new NavDrawer()
      $friends: new Friends()

  render: =>
    {$appBar, $menuButton, $marketplaceShare, $navDrawer, $friends} = @state()

    contentHeight = window.innerHeight - styleConfig.$appBarHeightShort

    z 'div.z-friends-page',
      z $appBar, {
        height: "#{styleConfig.$appBarHeightShort}px"
        $topLeftButton: $menuButton
        title: 'Friends'
      }
      z $navDrawer, {currentPage: NavDrawer.PAGES.FRIENDS.ROUTE}
      z 'div.l-content-container.content', {
        style:
          height: "#{contentHeight}px"
      },
        $friends
