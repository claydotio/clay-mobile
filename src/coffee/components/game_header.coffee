z = require 'zorium'
config = require '../config'

module.exports = class GameHeader
  constructor: ->
    host = window.location.host
    targetHost = config.HOSTNAME
    protocol = 'http:'

    unless host == targetHost
      protocol = if kik?.enabled then 'card:' else 'http:'
    @marketplaceUrl = "#{protocol}//#{targetHost}"

  render: =>
    z 'header.game-header', [
      z "a.game-header-logo[href=#{@marketplaceUrl}]"
    ]
