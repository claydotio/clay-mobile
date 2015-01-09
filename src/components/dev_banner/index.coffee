z = require 'zorium'

styles = require './index.styl'

module.exports = class DevBanner
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-banner',
      'Whoa, get off my lawn. '
      z 'a.link[href=/legacy]', 'Take me back to the legacy site.'
