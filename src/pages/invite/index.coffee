z = require 'zorium'

AppBar = require '../../components/app_bar'
MenuButton = require '../../components/menu_button'
Invite = require '../../components/invite'
NavDrawer = require '../../components/nav_drawer'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'


module.exports = class InvitePage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $menuButton: new MenuButton()
      $invite: new Invite()
      $navDrawer: new NavDrawer()

  render: =>
    {$appBar, $menuButton, $invite, $navDrawer} = @state()

    contentHeight = window.innerHeight - styleConfig.$appBarHeightMedium

    z 'div.z-invite-page',
      z $appBar, {
        height: "#{styleConfig.$appBarHeightMedium}px"
        isDescriptive: true
        $topLeftButton: $menuButton
        title: 'Invite Friends'
        description: 'Build your friends list, see what they play.'
      }
      z $navDrawer, {currentPage: 'invite'}
      z 'div.l-content-container.content', {
        style:
          height: "#{contentHeight}px"
      },
        $invite
