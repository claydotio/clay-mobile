z = require 'zorium'
Card = require 'zorium-paper/card'
Button = require 'zorium-paper/button'
Dropzone = require 'dropzone'

config = require '../../config'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ReqProfilePicCard
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      $addButton: new Button()
      isUploaded: false

  onMount: ($el) ->
    dropzone = new Dropzone $el, {
      url: "#{config.PUBLIC_CLAY_API_URL}/" # FIXME
      method: 'PUT'
      paramName: 'profile_pic'
      acceptedFiles: 'image/jpeg,image/png'
      success: (file, res) =>
        @state.set isUploaded: true
      error: (file, res) ->
        # TODO: (Austin) better error handling UX
        window.alert "Error: #{res.detail}"
    }

  render: =>
    {$card, $dismissButton, $addButton} = @state()

    z 'div.z-req-profile-pic-card',
      z $card,
        content:
          z 'div.z-req-profile-pic-card_content',
            z 'h2.title', 'Add a profile photo'
            z 'div.description', 'Add some personality to your profile :)'
            z 'div.actions',
              z $dismissButton,
                text: 'Dismiss'
                colors: c500: styleConfig.$white, ink: styleConfig.$orange500
              # .dz-message necessary to be clickable (no workaround)
              z 'div.dz-message.clickable',
                z $addButton,
                  text: 'Add'
                  colors: c500: styleConfig.$white, ink: styleConfig.$orange500
                  onclick: @uploadProfilePicture
