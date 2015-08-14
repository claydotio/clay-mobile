z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'

styles = require './index.styl'

module.exports = class DevInfo
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-info.l-content-container',
      z 'h1', 'Publish your mobile games to over 5 million players'
      z '.sdk-features',
        z '.sdk-feature',
          z 'i.icon.icon-cloud-upload'
          z '.title', 'Distribution'
          z '.info', 'Distribute your game to the Clay Marketplace and get
                      exposed to millions of players!'
        z '.sdk-feature',
          z 'i.icon.icon-ads'
          z '.title', 'Advertising'
          z '.info', 'Easily implement advertisements in your game to
                      start making money right away.'
        z '.sdk-feature',
          z 'i.icon.icon-share'
          z '.title', 'Social Sharing'
          z '.info', 'Get your players posting to Facebook, Twitter, Kik,
                      and more - inviting their friends to play your game!'
      z '.dev-actions',
        z 'a.button-primary.get-started' +
          "[href=https://#{config.DEV_HOST}/login]",
          'Get started!'
        z 'a.button-ghost.explore-sdk'+
          '[href=https://github.com/claydotio/clay-sdk]', 'Explore the SDK'
