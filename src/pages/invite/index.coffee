z = require 'zorium'

AppBar = require '../../components/app_bar'
Invite = require '../../components/invite'
NavDrawer = require '../../components/nav_drawer'

styles = require './index.styl'

APP_BAR_HEIGHT = 168

module.exports = class InvitePage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $invite: new Invite()
      $navDrawer: new NavDrawer()

  render: =>
    {$appBar, $invite, $navDrawer} = @state()

    z 'div.z-invite-page',
      z $appBar, {
        height: "#{APP_BAR_HEIGHT}px"
        barType: 'background'
        topLeftButton: 'menu'
        title: 'Invite Friends'
        description: 'Build your friends list, see what they play.'
      }
      z $navDrawer, {currentPage: 'invite'}
      z 'div.l-content-container.content', {
        style:
          height: "#{window.innerHeight - APP_BAR_HEIGHT}px"
      },
        $invite
