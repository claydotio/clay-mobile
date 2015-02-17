z = require 'zorium'
log = require 'clay-loglevel'

PaperCard = require '../paper_card'
PaperInput = require '../paper_input'
PaperButton = require '../paper_button'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    @state = z.state
      # 16px padding FIXME
      $formCard: new PaperCard {
        content: [
          # FIXME: add z '.z-join_form-card-content'
          new PaperInput
            hintText: 'Name'
            isFloating: true
            o_value: z.observe ''
            colors: c500: styleConfig.$orange
          new PaperInput
            hintText: 'Phone number'
            isFloating: true
            o_value: z.observe ''
            colors: c500: styleConfig.$orange
          new PaperInput
            hintText: 'Password'
            isFloating: true
            o_value: z.observe ''
            colors: c500: styleConfig.$orange
          # FIXME: align right when we fix the rendering stuff
          new PaperButton
            text: 'Sign up'
            colors: c500: styleConfig.$orange, ink: styleConfig.$white
        ]
      }
      showProfilePicture: z.observe false # FIXME

  render: ({$formCard, showProfilePicture}) ->
    z '.z-join',
      $formCard
      z 'div.terms',
        'By signing up, you agree to receive SMS messages and to our '
        z 'a[href=/privacy]', 'Privacy Policy'
        ' and '
        z 'a[href=/tos]', 'Terms'
        '.'
