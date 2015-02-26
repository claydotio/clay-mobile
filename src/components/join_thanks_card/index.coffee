z = require 'zorium'
Card = require 'zorium-paper/card'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class JoinThanksCard
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      dismissed: false

  render: ({newFriends}) =>
    {$card, $dismissButton, dismissed} = @state()

    if dismissed
      return

    z 'div.z-join-thanks-card',
      z $card,
        colors: c500: styleConfig.$blue500, ink: styleConfig.$white
        content:
          z 'div.z-join-thanks-card_content',
            z 'h1.thanks', 'Thanks for joining!'
            z 'div.description',
              'You\'ll receive a text message to confirm your account shortly. '
              'If texting isn\'t your thing, you can opt-out at any time.'
            z 'div.actions',
              z $dismissButton,
                text: 'Dismiss'
                colors: c500: styleConfig.$white, ink: styleConfig.$blue500
                onclick: =>
                  @state.set dismissed: true
