z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Invite
  constructor: ->
    styles.use()

    @state = z.state
      $continueButton: new Button()

  render: =>
    {$continueButton} = @state()

    z '.z-invite.l-flex.l-full-height',
      z 'div.invite-options',
        z 'a.invite',
          z 'span.social-icon.twitter'
          'Invite from Kik'
        z 'a.invite',
          z 'span.social-icon.facebook'
          'Invite from Facebook'
        z 'a.invite',
          z 'span.social-icon.twitter'
          'Invite from Twitter'
        z 'a.invite',
          z 'span.social-icon.twitter'
          'Invite by Text Message'
      z 'div.continue',
        z $continueButton,
          text: 'Continue'
          colors: c500: styleConfig.$orange, ink: styleConfig.$white
