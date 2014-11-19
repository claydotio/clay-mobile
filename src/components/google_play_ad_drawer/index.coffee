z = require 'zorium'
log = require 'clay-loglevel'

User = require '../../models/user'

styles = require './index.styl'

module.exports = class GooglePlayAdDrawer
  constructor: ->
    styles.use()

  openGooglePlay: ->
    User.convertExperiment('to_google_play').catch log.trace
    ga? 'send', 'event', 'to_google_play', 'convert'
    window.open 'https://play.google.com/store/apps/details?id=com.clay.clay'

  render: ->
    z 'div.google-play-ad-drawer',
      z 'div.google-play-ad-drawer-flexbox',
        z 'div.google-play-ad-drawer-icon',
          z 'img',
            src: '//cdn.wtf/d/images/google_play/google_play_icon.svg'
            width: 22
            height: 24
        z 'div.google-play-ad-drawer-content',
          z 'h2', 'Get the app!'
          z 'div.google-play-ad-drawer-message',
            'Play your favorite games even faster. '
            'Official app now on Google Play!'
      z 'button.button-secondary.is-block',
        onclick: @openGooglePlay,
        'Download now'
