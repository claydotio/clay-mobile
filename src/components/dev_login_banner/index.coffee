z = require 'zorium'

styles = require './index.styl'

module.exports = class DevLoginBanner
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-dev-login-banner',
      z 'div.l-flex.is-vertical-center',
        z 'div.content',
          z 'div', 'Welcome, developers.'
          z 'div', 'Sign in to start publishing'
