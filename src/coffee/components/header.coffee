z = require 'zorium'

module.exports = class Header
  render: ->
    z 'header.header', [
      z '.header-logo', [
        z 'img', src: 'http://clay.io/images/logo-cloud.png'
        z 'span.clay', 'Clay'
        z 'span.io', '.io'
      ]
    ]
