z = require 'zorium'

module.exports = class Splash
  constructor: -> null

  login: (e) ->
    e?.stopPropagation()
    # TODO

  render: =>
    z 'div.splash',
      z 'div.splash-info',
        z 'div.splash-info-logo'
        z 'div.splash-info-headlines',
          z 'p.splash-info-headline', "It's all about the ",
                                      z('strong', 'challenges')
          z 'p.splash-info-headline',
            'Can ', z('strong', 'you '),
            'have the ', z('strong', 'top '), 'score?'
      z 'div.splash-actions', # 80px
          z 'button.button-primary.splash-login', onclick: @login,
            'Sign in to start playing'
