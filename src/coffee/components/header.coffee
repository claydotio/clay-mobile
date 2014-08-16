z = require 'zorium'

module.exports = class Header
  render: ->
    z 'header.header', [
      z 'a.header-logo[href=/]', {config: z.route}, [
        z 'img', src: 'http://clay.io/images/logo-cloud.png'
        z 'span.clay', 'Clay'
        z 'span.io', '.io'
      ]
    ]
