z = require 'zorium'
Card = require 'zorium-paper/card'
Button = require 'zorium-paper/button'
Dropzone = require 'dropzone'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ReqProfilePicCard
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      $addButton: new Button()

  render: =>
    {$card, $dismissButton, $addButton} = @state()

    z 'div.z-req-profile-pic-card',
      z 'input#profile-pic-input[type=file][accept=image/*]'
      z $card,
        content:
          z 'div.z-req-profile-pic-card_content',
            z 'h2.title', 'Add a profile photo'
            z 'div.description', 'Add some personality to your profile :)'
            z 'div.actions',
              z $dismissButton,
                text: 'Dismiss'
                colors: c500: styleConfig.$white, ink: styleConfig.$orange
              z $addButton,
                text: 'Add'
                colors: c500: styleConfig.$white, ink: styleConfig.$orange
                onclick: @uploadProfilePicture
