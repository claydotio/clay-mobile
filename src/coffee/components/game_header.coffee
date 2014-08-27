z = require 'zorium'
config = require '../config'

module.exports = class GameHeader
  constructor: ->
    host = window.location.host
    targetHost = config.APP_HOST
    protocol = 'http:'

    unless host == targetHost
      protocol = if kik?.enabled then 'card:' else 'http:'
    @marketplaceUrl = "#{protocol}//#{config.APP_HOST}"

  render: =>
    z 'header.game-header', [
      z "a.game-header-logo[href=#{@marketplaceUrl}]"
    ]
