z = require 'zorium'

CategoriesForm = require './categories_form'

module.exports = class Welcome
  constructor: ->
    @CategoriesForm = new CategoriesForm()

  completeSignup: (e) ->
    e?.stopPropagation()
    # TODO

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
        z 'input#email-phone.is-full',
          type: 'text', placeholder: 'Email / cell phone #'
        # categories block
        z 'div.welcome-content-input-header', 'What kind of games do you like?'
        @CategoriesForm.render()
        z 'button.button-primary.is-full.welcome-content-start-playing',
          {onclick: @completeSignup}, 'Start playing!'
