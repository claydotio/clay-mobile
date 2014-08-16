z = require 'zorium'
config = require '../config'

module.exports = class GameHeader
  constructor: ->
    host = window.location.host
    targetHost = config.APP_HOST
    protocol = 'http:'

    unless host == targetHost
      protocol = 'card:'
    @marketplaceUrl = "#{protocol}//#{config.APP_HOST}"

  render: =>
    z 'header.game-header', [
      z "a.game-header-logo[href=#{@marketplaceUrl}]", [
        z 'img', src: 'http://clay.io/images/logo-cloud.png'
      ]
    ]
