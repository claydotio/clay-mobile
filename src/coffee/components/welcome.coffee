z = require 'zorium'

module.exports = class Welcome
  constructor: -> null

  login: (e) ->
    e?.stopPropagation()
    # TODO

  render: =>
    z 'div.welcome',
      z 'div.welcome-header',
        z 'div.welcome-header-description', 'Welcome to clay.io,'
        z 'div.welcome-header-username', 'USERNAME'
      z 'div.welcome-content',
          z 'button.splash-login', onclick: @login,
            'Sign in to start playing'
