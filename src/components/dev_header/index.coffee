z = require 'zorium'

styles = require './index.styl'

module.exports = class DevHeader
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-header',
      z '.l-content-container.l-flex.l-vertical-center',
        z.router.a '.logo[href=/developers]',
          z 'img[src=//cdn.wtf/d/images/logos/logo_dev.svg]'
        z 'nav.navigation',
          z 'ul',
            z 'li.is-selected',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=/developers]', 'Dashboard'
            z 'li',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=https://github.com/claydotio/clay-sdk]
                            [target=_blank]',
                'Dev Docs'
            z 'li',
              z 'div.l-flex.l-vertical-center',
                z.router.a '[href=/developers/logout]', 'Sign out'
