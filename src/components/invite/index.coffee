z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

config = require '../../config'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Invite
  constructor: ->
    styles.use()

    @state = z.state
      $continueButton:
        new Button()

  render: =>
    {$continueButton} = @state()

    z '.z-invite',
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
      # FIXME: implement easy way to push buttons all the way to bottom of page
      # and have them pushed down if there's more content
      z 'div.continue',
        z $continueButton,
          text: 'Continue'
          colors: c500: styleConfig.$orange, ink: styleConfig.$white
