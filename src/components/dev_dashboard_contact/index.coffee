z = require 'zorium'

SocialIcons = require '../social_icons'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class DevDashboardContact
  constructor: ->
    styles.use()

    @state = z.state
      SocialIcons: new SocialIcons()

  render: ({SocialIcons}) ->
    z 'div.z-dev-dashboard-contact',
      z 'h1', 'Get in touch with us.'
      z 'div',
        'Have a general question? Experiencing issues and need help? '
        'Let us know!'
      z 'div.buttons',
        z 'a.button-primary.contact-us[href=mailto:contact@clay.io]',
          'Contact us'
        z 'a.button-secondary.submit-feedback[href=mailto:contact@clay.io]',
          'Submit feedback'
      z 'h1', 'Just looking to say hi?'
      z 'div', 'Get social and follow us.'
      z 'div.social',
        SocialIcons
