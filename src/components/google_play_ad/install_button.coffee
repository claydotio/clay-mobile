z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'

styles = require './install_button.styl'

module.exports = class GooglePlayAd
  constructor: ->
    styles.use()

  openGooglePlay: ->
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ->
    z 'div.l-content-container',
      z 'a.google-play-ad
        [href=https://play.google.com/store/apps/details?id=com.clay.clay]',
        onclick: @openGooglePlay
        z 'div.google-play-ad-header'
        z 'div.google-play-ad-content',
          z 'h2', 'Get the app!'
          z 'div.google-play-ad-message',
            z 'div', 'Play your favorite games even faster. '
            z 'div', 'Official app now on Google Play!'
        z 'button.button-ghost.is-block.google-play-ad-button',
          z 'i.icon.icon-arrow-down'
          z 'span.google-play-ad-modal-button-text', 'Install now'
