z = require 'zorium'

Icon = require '../icon'
ButtonPrimary = require '../button_primary'
InviteService = require '../../services/invite'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

shareMethods =
  kik:
    title: 'Invite from Kik'
    icon: 'kik'
    inviteFn: InviteService.sendKikInvite
  facebook:
    title: 'Invite from Facebook'
    icon: 'facebook'
    inviteFn: InviteService.sendFacebookInvite
  twitter:
    title: 'Invite from Twitter'
    icon: 'twitter'
    inviteFn: InviteService.sendTwitterInvite

module.exports = class Invite
  constructor: ->
    styles.use()

    @state = z.state
      $icons: _.mapValues shareMethods, (method) ->
        new Icon()
      $continueButton: new ButtonPrimary()
      me: z.observe User.getMe()

  render: =>
    {$icons, $continueButton, me} = @state()

    z '.z-invite',
      z 'div.invite-options',
        _.map shareMethods, (method, key) ->
          z 'a[href=#].invite', {
            onclick: ->
              method.inviteFn {userId: me.id}
          },
            z "div.social-icon.#{key}",
              z 'div.icon',
                z $icons[key],
                  icon: method.icon
                  size: '24px'
                  color: styleConfig.$white
            z 'div', method.title

      z 'div.continue',
        z $continueButton,
          text: 'Continue'
          onclick: ->
            z.router.go '/'
