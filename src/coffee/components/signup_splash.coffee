z = require 'zorium'

module.exports = class SignupSplash
  constructor: -> null

  signup: (e) ->
    e?.stopPropagation()
    # TODO

  render: =>
    z 'div.signup-splash',
      # req. for height 100% - space for signup-splash-actions
      z 'div.signup-splash-header',
        z 'div.signup-splash-header-content-container', # req. for vert. center
          z 'div.signup-splash-header-content',
            z 'div.signup-splash-header-content-logo'
            z 'div.signup-splash-header-content-headlines',
              z 'p.signup-splash-header-content-headline',
                "It's all about the ", z('strong', 'challenges')
              z 'p.signup-splash-header-content-headline',
                'Can ', z('strong', 'you '),
                'have the ', z('strong', 'top '), 'score?'
      z 'div.signup-splash-actions',
          z 'button.button-primary.signup-splash-signup.is-full-width',
          {onclick: @signup}, 'Sign in to start playing'
