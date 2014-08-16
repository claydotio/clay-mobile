z = require 'zorium'

module.exports = class Header
  render: ->
    z 'header.game-header', [
      z 'a.game-header-logo[href=/]', {config: z.route}, [
        z 'img', src: 'http://clay.io/images/logo-cloud.png'
      ]
    ]
