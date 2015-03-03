z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class JoinThanksCard
  constructor: ->
    styles.use()

    @state = z.state
      $dismissButton: new Button()
      isDismissed: false

  render: ({newFriends}) =>
    {$dismissButton, isDismissed} = @state()

    # TODO: (Austin) re-implement as stream where parent handles show/hide
    if isDismissed
      return

    z 'div.z-join-thanks-card',
      z 'h1.thanks', 'Thanks for joining!'
      z 'div.description',
        'You\'ll receive a welcome text message shortly. '
        'If texting isn\'t your thing, you can opt-out at any time.'
      z 'div.actions',
        z $dismissButton,
          text: 'Dismiss'
          colors:
            c500: styleConfig.$white
            ink: styleConfig.$blue500
          onclick: =>
            @state.set isDismissed: true
