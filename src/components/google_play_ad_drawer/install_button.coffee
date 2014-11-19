z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'

styles = require './install_button.styl'

module.exports = class GooglePlayAdDrawer
  constructor: ->
    styles.use()

  openGooglePlay: ->
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ->
    z 'div.google-play-ad-drawer',
      z 'div.google-play-ad-drawer-content',
        z 'div.google-play-ad-drawer-content-text',
          z 'h2', 'Get the app!'
          z 'div', 'Play your favorite games even faster. '
          z 'div', 'Official app now on Google Play!'
      z 'button.button-ghost.is-block.google-play-ad-drawer-button',
        onclick: @openGooglePlay,
        z 'i.icon.icon-arrow-down'
        z 'span.google-play-ad-drawer-button-text', 'Install now'
