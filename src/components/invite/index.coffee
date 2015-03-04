z = require 'zorium'

Icon = require '../icon'
PrimaryButton = require '../primary_button'
InviteService = require '../../services/invite'
EnvironmentService = require '../../services/environment'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Invite
  constructor: ->
    styles.use()

    @state = z.state
      shareMethods: [
        {
          className: 'kik'
          title: 'Invite from Kik'
          $icon: new Icon()
          iconName: 'kik'
          inviteFn: InviteService.sendKikInvite
        }
        {
          className: 'facebook'
          title: 'Invite from Facebook'
          $icon: new Icon()
          iconName: 'facebook'
          inviteFn: InviteService.sendFacebookInvite
        }
        {
          className: 'twitter'
          title: 'Invite from Twitter'
          $icon: new Icon()
          iconName: 'twitter'
          inviteFn: InviteService.sendTwitterInvite
        }
      ]
      $continueButton: new PrimaryButton()
      me: z.observe User.getMe()

  render: =>
    {shareMethods, $continueButton, me} = @state()

    z '.z-invite',
      z 'div.invite-options',
        _.map shareMethods, ({className, title, $icon, iconName, inviteFn}) ->
          if className is 'kik' and not EnvironmentService.isKikEnabled()
            return
          z 'a[href=#].invite', {
            onclick: ->
              inviteFn {userId: me.id}
          },
            z "div.social-icon.#{className}",
              z 'div.icon',
                z $icon,
                  isTouchTarget: false
                  icon: iconName
                  color: styleConfig.$white
            z 'div', title

      z 'div.continue',
        z $continueButton,
          text: 'Continue'
          onclick: ->
            z.router.go '/'
