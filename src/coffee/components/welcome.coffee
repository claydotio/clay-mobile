z = require 'zorium'

CategoriesInput = require './categories_input'

module.exports = class Welcome
  constructor: ->
    @CategoriesInput = new CategoriesInput()

  completeSignup: (e) ->
    e?.stopPropagation()
    # FIXME: implement functionality that saves this info

  render: =>
    z 'div.welcome',
      z 'div.welcome-header',
        z 'div.welcome-header-content',
          z 'div.welcome-header-description', 'Welcome to clay.io,'
          z 'div.welcome-header-username', 'USERNAME'
      z 'div.welcome-content',
        z 'div.welcome-content-description', "You're going to have a ton of fun"
        # email/phone block
        z 'div.welcome-content-input-header',
          'First, we need a little info to get started.'
        z 'input#email-phone.is-full-width',
          type: 'text', placeholder: 'Email / cell phone #'
        # categories block
        z 'div.welcome-content-input-header', 'What kind of games do you like?'
        @CategoriesInput.render()
        # start playing
        z 'button.button-primary.welcome-content-start-playing.is-full-width',
          {onclick: @completeSignup}, 'Start playing!'
