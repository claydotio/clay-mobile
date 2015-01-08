z = require 'zorium'
_ = require 'lodash'

config = require '../../config'
Game = require '../../models/game'
DevImageUpload = require '../dev_image_upload'
InputBlock = require '../input_block'
InputBlockRadio = require '../input_block_radio'
InputSelect = require '../input_select'
InputTextarea = require '../input_textarea'
InputRadio = require '../input_radio'

categories = {
  arcade: 'Arcade',
  action: 'Action',
  puzzle: 'Puzzle'
}

categoryOptions = _.map categories, (label, value) ->
  return {label, value}

styles = require './index.styl'

module.exports = class DevEditGameDetails
  constructor: ->
    styles.use()

    @state = z.state
      gameId: null
      iconUpload: null
      accentUpload: null
      headerUpload: null
      screenshotUpload1: null
      screenshotUpload2: null
      screenshotUpload3: null
      screenshotUpload4: null
      screenshotUpload5: null
      categoryBlock: new InputBlock {
        label: 'Category'
        input: new InputSelect({options: categoryOptions})
      }
      descriptionBlock: new InputBlock {
        label: 'Description'
        input: new InputTextarea value: ''
      }
      orientationBlock: new InputBlockRadio {
        radios: [
          new InputRadio label: 'Portrait', value: 'portrait'
          new InputRadio label: 'Landscape', value: 'landscape'
          new InputRadio label: 'Both', value: 'both', isChecked: true
        ]
      }

  onMount: =>
    Game.getEditingGame().then (game) =>
      @state().descriptionBlock.input.setValue game.description
      @state.set
        gameId: game.id
        iconUpload: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/iconImage"
          inputName: 'iconImage'
          label: 'Icon'
          renderHeight: 110
          width: 512
          height: 512
        )
        accentUpload: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/accentImage"
          inputName: 'accentImage'
          label: 'Accent'
          renderHeight: 110
          width: 900
          height: 300
        )
        headerUpload: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/headerImage"
          inputName: 'headerImage'
          label: 'Header'
          renderHeight: 110
          width: 2550
          height: 850
          safeWidth: 1700
          safeHeight: 850
        )
        screenshotUpload1: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload2: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload3: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload4: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload5: new DevImageUpload(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          renderHeight: 110
          width: 320
          height: 320
        )

  saveAndContinue: (e) =>
    e?.preventDefault()

    orientation = @state().orientationBlock.getChecked().getValue()
    isPortrait = orientation is 'both' or orientation is 'portrait'
    isLandscape = orientation is 'both' or orientation is 'landscape'
    # FIXME: update these when backend for them is done

    # images saved immediately (not need to hit 'next step')
    Game.update(@state().gameId, {
      description: @state().descriptionBlock.input.getValue()
    }).then =>
      z.router.go "/developers/edit-game/upload/#{@state().gameId}"

  render: (
    {
      categoryBlock
      descriptionBlock
      orientationBlock
      iconUpload
      accentUpload
      headerUpload
      screenshotUpload1
      screenshotUpload2
      screenshotUpload3
      screenshotUpload4
      screenshotUpload5
    }
  ) ->
    z 'div.z-dev-edit-game-details',
      z 'form',
        {onsubmit: @saveAndContinue},

        categoryBlock
        descriptionBlock
        orientationBlock

        z 'hr'

        z 'h2.title', 'Graphics ',
          z 'i.icon.icon-help',
            title: 'We require a few images for your game to make sure it
            looks great and get more people playing.'

        iconUpload
        accentUpload
        headerUpload

        z 'h2.title',
          'Screenshots'
          z 'div.label-info', '2 required, minimum 320px dimension'

        # FIXME: ability to remove screenshots
        screenshotUpload1
        screenshotUpload2
        screenshotUpload3
        screenshotUpload4
        screenshotUpload5

        z 'div.l-flex',
          z 'div.l-flex-right',
            z 'button.button-secondary.next-step',
              # FIXME: check that all images, etc... are uploaded
              unless true
                disabled: true
              ,
              'Next step'
