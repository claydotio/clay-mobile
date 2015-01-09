z = require 'zorium'

styles = require './index.styl'

module.exports = class DevLoginPlayerMessage
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-dev-login-player-message',
      z 'div.l-content-container.content',
        z 'h1', 'Are you a player?'
        z 'div', 'Download our Android app or visit Clay on Kik or your
                  web browser to play.'
        z 'div.links',
          z 'img.google-play' +
            '[src=//cdn.wtf/d/images/google_play/google_play_get_it.svg]'
          z 'img.kik[src=//cdn.wtf/d/images/kik/kik_logo.svg]'
