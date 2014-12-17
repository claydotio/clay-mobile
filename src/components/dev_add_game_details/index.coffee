z = require 'zorium'
_ = require 'lodash'

Game = require '../../models/game'
DevImageUpload = require '../dev_image_upload'
InputBlock = require '../input_block'
InputBlockRadio = require '../input_block_radio'
InputSelect = require '../input_select'
InputText = require '../input_text'
InputTextarea = require '../input_textarea'
InputRadio = require '../input_radio'

categories = {
  arcade: 'Arcade',
  action: 'Action',
  puzzle: 'Puzzle'
}
# FIXME: map over object
categoryOptions = _.map categories, (category) ->
  label: ''#label
  value: ''#value

styles = require './index.styl'

module.exports = class DevDashboardGames
  constructor: ->
    styles.use()

    @state = z.state
      iconUpload: new DevImageUpload(
        type: 'Icon'
        renderHeight: 110
        width: 512
        height: 512
      )
      accentUpload: new DevImageUpload(
        type: 'Accent'
        renderHeight: 110
        width: 900
        height: 300
      )
      headerUpload: new DevImageUpload(
        type: 'Header'
        renderHeight: 110
        width: 2550
        height: 850
        safeWidth: 1700
        safeHeight: 850
      )
      category: new InputBlock {
        label: 'Category'
        input: new InputSelect({options: categoryOptions})
      }
      description: new InputBlock {
        label: 'Description'
        input: new InputTextarea value: ''
      }
      orientation: new InputBlockRadio {
        radios: [
          new InputRadio label: 'Portrait', value: 'portrait'
          new InputRadio label: 'Landscape', value: 'landscape'
          new InputRadio label: 'Both', value: 'both'
        ]
      }
      videoUrl: new InputBlock {
        label: 'Video URL'
        input: new InputText value: ''
      }


    if Game.getEditingGame()
      Game.getEditingGame().then (game) =>
        @state.set
          gameDescription: game.description

  render: ->
    z 'div.z-dev-add-game-details',
      z 'form',
        @state().category
        @state().description
        @state().orientation

        z 'hr'

        z 'h2.title', 'Graphics ',
          z 'i.icon.icon-help',
            title: 'We require a few images for your game to make sure it
            looks great and get more people playing.'

        @state().iconUpload
        @state().accentUpload
        @state().headerUpload

        z 'h2.title', 'Screenshots'

        @state().videoUrl

        z 'div.l-flex',
          z 'div.l-flex-right',
            z 'button.button-secondary.next-step',
              # FIXME: check that all images, etc... are uploaded
              unless true
                disabled: true
              ,
              'Next step'
