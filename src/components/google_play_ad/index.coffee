z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'

styles = require './index.styl'

module.exports = class GooglePlayAd
  constructor: ->
    styles.use()

  openGooglePlay: (e) ->
    e.preventDefault()
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: =>
    z 'div.l-content-container',
      z 'a.z-google-play-ad
        [href=https://play.google.com/store/apps/details?id=com.clay.clay]',
        onclick: @openGooglePlay
        z 'div.header'
        z 'div.content',
          z 'h2', 'Get the app!'
          z 'div.message',
            z 'div', 'Play your favorite games even faster. '
            z 'div', 'Official app now on Google Play!'
        z 'button.button-ghost.is-block.install-button',
          z 'i.icon.icon-arrow-down'
          z 'span.button-text', 'Install now'
