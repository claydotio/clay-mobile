z = require 'zorium'

styles = require './index.styl'

module.exports = class DevHeader
  constructor: ->
    styles.use()

  render: ->
    z '.z-guest-header',
      z '.l-content-container.l-flex.l-vertical-center',
        z.router.a '.logo[href=/]',
          z 'img[src=//cdn.wtf/d/images/logos/logo.svg]'
        z 'nav.navigation',
          z 'ul',
            z 'li',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=/developers/login]', 'Sign in'
