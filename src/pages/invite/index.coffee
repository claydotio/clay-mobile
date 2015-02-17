z = require 'zorium'

AppBar = require '../../components/app_bar'
Invite = require '../../components/invite'

styles = require './index.styl'

module.exports = class InvitePage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $invite: new Invite()

  render: =>
    {$appBar, $invite} = @state()

    z 'div.z-invite-page',
      z $appBar, {
        height: '168px'
        barType: 'background'
        title: 'Invite Friends'
        description: 'Build your friends list, see what they play.'
      }
      z 'div.l-content-container.content',
        $invite
