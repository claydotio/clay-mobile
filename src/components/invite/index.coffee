z = require 'zorium'
Button = require 'zorium-paper/button'

Icon = require '../icon'
InviteService = require '../../services/invite'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

SHARE_METHODS =
  kik:
    title: 'Invite from Kik'
    icon: 'kik'
    inviteMethod: InviteService.sendKikInvite
  facebook:
    title: 'Invite from Facebook'
    icon: 'facebook'
    inviteMethod: InviteService.sendFacebookInvite
  twitter:
    title: 'Invite from Twitter'
    icon: 'twitter'
    inviteMethod: InviteService.sendTwitterInvite
  sms:
    title: 'Invite by Text Message'
    icon: 'chat'
    inviteMethod: InviteService.sendSMSInvite

module.exports = class Invite
  constructor: ->
    styles.use()

    @state = z.state
      $icons: _.reduce SHARE_METHODS, (icons, method) ->
        icons[method.icon] = new Icon()
        return icons
      , {}
      $continueButton: new Button()
      me: z.observe User.getMe()

  render: =>
    {$icons, $continueButton, me} = @state()

    z '.z-invite.l-flex.l-full-height',
      z 'div.invite-options',
        _.map SHARE_METHODS, (method, key) ->
          z 'a[href=#].invite.l-flex.l-vertical-center', {
            onclick: ->
              method.inviteMethod {userId: me.id}
          },
            z "div.social-icon.#{key}.l-flex",
              z 'div.icon',
                z $icons[method.icon],
                  icon: method.icon
                  size: '24px'
                  color: styleConfig.$white
            z 'div', method.title

      z 'div.continue',
        z $continueButton,
          text: 'Continue'
          colors: c500: styleConfig.$orange500, ink: styleConfig.$white
          onclick: ->
            z.router.go '/'
