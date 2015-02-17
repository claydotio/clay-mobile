z = require 'zorium'

AppBar = require '../../components/app_bar'
Invite = require '../../components/invite'

styles = require './index.styl'

module.exports = class InvitePage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar {
        height: '168px'
        barType: 'background'
        title: 'Invite Friends'
        description: 'Build your friends list, see what they play.'
      }
      $invite: new Invite()

  render: ({$appBar, $invite}) ->
    z 'div.z-invite-page',
      $appBar
      z 'div.l-content-container.content',
        $invite
