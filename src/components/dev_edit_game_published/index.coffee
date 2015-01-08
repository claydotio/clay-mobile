z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class DevEditGamePublished
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-dev-edit-game-published',
      z 'i.icon.icon-happy'
      z 'h1', 'Awesome!'
      z 'div.game-published', 'Your game has been published.'
      z 'div.play-now', 'Play it now at ',
        z 'a[href=#]', 'yourdomain.clay.io'
      z.router.a '[href=/developers].button-secondary.go-to-dashboard',
        'Go to dashboard'
      z 'div',
        z.router.a '[href=#].edit-game', 'Edit game listing'
