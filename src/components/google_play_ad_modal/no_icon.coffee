z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
ModalHeader = require '../modal_header'

styles = require './no_icon.styl'

module.exports = class GooglePlayAdModal
  constructor: ->
    styles.use()

    @state = z.state
      modalHeader: new ModalHeader(
        title: 'Get the app'
        isDark: true
        backgroundImage: '//cdn.wtf/d/images/google_play/google_play_banner.png'
      )

  onMount: ->
    ga? 'send', 'event', 'google_play_ad_modal', 'open'

  openGooglePlay: (e) ->
    e.preventDefault()
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ({modalHeader}) =>
    z 'div.z-google-play-ad-modal-flat',
      modalHeader
      z 'div.content',
        z 'div.message',
          'Play your favorite games even faster. '
          'Install the app from Google Play!'
        z '.align-right',
          z 'button.button-flat.install-button',
            {onclick: @openGooglePlay},
            'INSTALL'
