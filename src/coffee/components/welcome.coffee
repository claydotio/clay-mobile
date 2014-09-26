z = require 'zorium'

module.exports = class Welcome
  constructor: -> null

  login: (e) ->
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
        z 'input#email-phone.is-full', type: 'text', placeholder: 'Email / cell phone #'
        # categories block
        z 'div.welcome-content-input-header', 'What kind of games do you like?'
        # TODO: checkbox component?
        # TODO: categories component
        z 'div.welcome-content-checkboxes',
          z 'div.welcome-content-checkbox-container',
            z 'input#category-action', type: 'checkbox', name: 'action'
            z 'label', {for: 'category-action'}, 'Action'
          z 'div.welcome-content-checkbox-container',
            z 'input#category-puzzle', type: 'checkbox', name: 'puzzle'
            z 'label', {for: 'category-puzzle'}, 'Puzzle'
          z 'div.welcome-content-checkbox-container',
            z 'input#category-sports', type: 'checkbox', name: 'sports'
            z 'label', {for: 'category-sports'}, 'Sports'
          z 'div.welcome-content-checkbox-container',
            z 'input#category-strategy', type: 'checkbox', name: 'strategy'
            z 'label', {for: 'category-strategy'}, 'Strategy'

        z ''
          z 'button.button-primary.is-full.welcome-content-start-playing',
            {onclick: @login}, 'Start playing!'
