z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'
ModalHeader = require '../modal_header'

styles = require './index.styl'

module.exports = class GooglePlayAdModal
  constructor: ->
    styles.use()

    @ModalHeader = new ModalHeader {title: 'Get the app'}

  onMount: ->
    ga? 'send', 'event', 'google_play_ad_modal', 'open'

  openGooglePlay: ->
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ->
    z 'div.google-play-ad-modal',
      @ModalHeader
      z 'div.google-play-ad-modal-content',
        z 'div.google-play-ad-modal-icon',
          z 'img',
            src: '//cdn.wtf/d/images/google_play/google_play_icon.svg'
            width: 60
            height: 66
        z 'div.google-play-ad-modal-message',
          'Play your favorite games even faster. '
          'Official app now on Google Play!'
        z 'button.button-primary.is-block',
          onclick: @openGooglePlay,
          'Download now'
