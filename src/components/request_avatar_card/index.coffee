z = require 'zorium'
Button = require 'zorium-paper/button'
Dropzone = require 'dropzone'

config = require '../../config'
User = require '../../models/user'
Card = require '../card'
EnvironmentService = require '../../services/environment'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

dataUriToBlob = (dataUri) ->
  binary = atob(dataUri.split(',')[1])
  byteArray = _.map _.range(binary.length), (i) ->
    binary.charCodeAt(i)
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  return new Blob([new Uint8Array(byteArray)], {type: mimeString})

module.exports = class RequestAvatar
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      $addButton: new Button()
      dropzone: null
      isUploaded: false
      isDismissed: false

  onMount: ($el) =>
    User.getMe().then ({accessToken}) =>
      @state.set dropzone: new Dropzone($el, {
        url: "#{config.PUBLIC_CLAY_API_URL}/users/me/avatarImage" +
             "?accessToken=#{accessToken}"
        method: 'PUT'
        paramName: 'image'
        acceptedFiles: 'image/jpeg,image/png'
        previewsContainer: false
        success: (file, res) =>
          @state.set isUploaded: true
          User.setMe User.getMe().then (me) ->
            me.avatarImage = res
            return me
          ga? 'send', 'event', 'user', 'upload_avatar'

        error: (file, res) ->
          # TODO: (Austin) better error handling UX
          window.alert "Error: #{res.detail}"
      })

  render: =>
    {$card, $dismissButton, $addButton, isUploaded, isDismissed} = @state()

    # TODO: (Austin) re-implement as stream
    if isUploaded or isDismissed
      return

    z 'div.z-request-avatar-card',
      z $card,
        content:
          z 'div.z-request-avatar-card_content',
            z 'h2.title', 'Add a profile photo'
            z 'div.description', 'Add some personality to your profile :)'
            z 'div.actions',
              z $dismissButton,
                text: 'Dismiss'
                colors:
                  c500: styleConfig.$white
                  ink: styleConfig.$orange500
                onclick: =>
                  @state.set isDismissed: true
              # .dz-message necessary to be clickable (no workaround)
              z 'div.dz-message.clickable',
                z $addButton,
                  text: 'Add'
                  colors:
                    c500: styleConfig.$white
                    ink: styleConfig.$orange500
                  onclick: =>
                    if EnvironmentService.isKikEnabled()
                      kik.photo?.get? {
                        minResults: 1
                        maxResults: 1
                      }, (photos) =>
                        @state().dropzone.addFile dataUriToBlob photos[0]
