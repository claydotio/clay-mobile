z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'

styles = require './index.styl'

module.exports = class GooglePlayAd
  constructor: ->
    styles.use()

  openGooglePlay: ->
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ->
    z 'a.z-google-play-ad
      [href=https://play.google.com/store/apps/details?id=com.clay.clay]',
      onclick: @openGooglePlay
      z 'div.l-content-container',
        z 'div.l-flex',
          z 'div.google-play-icon',
            z 'img',
              src: '//cdn.wtf/d/images/google_play/google_play_icon.svg'
              width: 28
              height: 31
          z 'div.content',
            z 'h2', 'Get the app!'
            z 'div.message',
              z 'div', 'Play your favorite games even faster. '
              z 'div', 'Official app now on Google Play!'
          z 'div.download',
            z 'button.button-circle.is-blue.install-button',
              z 'i.icon.icon-arrow-right'
