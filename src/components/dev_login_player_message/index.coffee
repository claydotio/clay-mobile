z = require 'zorium'

styles = require './index.styl'

module.exports = class DevLoginPlayerMessage
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-dev-login-player-message',
      z 'div.l-content-container',
        z 'h1', 'Are you a player?'
        z 'div', 'Download our Android app or visit Clay on Kik or your
                  web browser to play.'
        z 'a.google-play-link'
        z 'a.kik-logo'
