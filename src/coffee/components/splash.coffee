z = require 'zorium'

module.exports = class Splash
  constructor: -> null

  signup: (e) ->
    e?.stopPropagation()
    # TODO

  render: =>
    z 'div.splash',
      z 'div.splash-header', # req. for height 100% - space for splash-actions
        z 'div.splash-header-content-container', # req. for vertical center
          z 'div.splash-header-content',
            z 'div.splash-header-content-logo'
            z 'div.splash-header-content-headlines',
              z 'p.splash-header-content-headline', "It's all about the ",
                                          z('strong', 'challenges')
              z 'p.splash-header-content-headline',
                'Can ', z('strong', 'you '),
                'have the ', z('strong', 'top '), 'score?'
      z 'div.splash-actions',
          z 'button.button-primary.splash-signup.is-full', onclick: @signup,
            'Sign in to start playing'
