z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
Game = require '../../models/game'
ImageUploader = require '../image_uploader'
InputBlock = require '../input_block'
InputBlockRadio = require '../input_block_radio'
InputSelect = require '../input_select'
InputTextarea = require '../input_textarea'
InputRadio = require '../input_radio'

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
        input: new InputSelect {
          options: [
            {label: 'Action', value: 'action'}
            {label: 'Adventure', value: 'adventure'}
            {label: 'Arcade', value: 'arcade'}
            {label: 'Puzzle', value: 'puzzle'}
            {label: 'Racing', value: 'racing'}
            {label: 'Stategy', value: 'strategy'}
          ]
        }
      }
      descriptionBlock: new InputBlock {
        label: 'Description'
        input: new InputTextarea value: ''
      }
      orientationBlock: new InputBlockRadio {
        radios: [
          new InputRadio {
            label: 'Portrait'
            name: 'orientation'
            value: 'portrait'
          }
          new InputRadio {
            label: 'Landscape'
            name: 'orientation'
            value: 'landscape'
          }
          new InputRadio {
            label: 'Both'
            name: 'orientation'
            value: 'both'
            isChecked: true
          }
        ]
      }
      devicesBlock: new InputBlockRadio {
        radios: [
          new InputRadio label: 'Desktop', name: 'devices', value: 'desktop'
          new InputRadio label: 'Mobile', name: 'devices', value: 'mobile'
          new InputRadio {
            label: 'Both'
            name: 'devices'
            value: 'both'
            isChecked: true
          }
        ]
      }

    Game.getEditingGame().then (game) =>
      @state().descriptionBlock.input.setValue game.description
      @state.set
        gameId: game.id
        iconUpload: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/iconImage"
          inputName: 'iconImage'
          thumbnail: game.iconImage
          label: 'Icon'
          renderHeight: 110
          width: 512
          height: 512
        )
        accentUpload: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/accentImage"
          inputName: 'accentImage'
          thumbnail: game.accentImage
          label: 'Accent'
          renderHeight: 110
          width: 900
          height: 300
        )
        headerUpload: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/headerImage"
          inputName: 'headerImage'
          thumbnail: game.headerImage
          label: 'Header'
          renderHeight: 110
          width: 2550
          height: 850
          safeWidth: 1700
          safeHeight: 850
        )
        screenshotUpload1: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          thumbnail: game.screenshotImages?[0]
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload2: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          thumbnail: game.screenshotImages?[1]
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload3: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          thumbnail: game.screenshotImages?[2]
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload4: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          thumbnail: game.screenshotImages?[3]
          renderHeight: 110
          width: 320
          height: 320
        )
        screenshotUpload5: new ImageUploader(
          url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
          method: 'post'
          inputName: 'screenshotImage'
          thumbnail: game.screenshotImages?[4]
          renderHeight: 110
          width: 320
          height: 320
        )

  onBeforeUnmount: =>
    @save()
    .catch log.trace

  save: =>
    devices = @state().devicesBlock.getChecked().getValue()
    isDesktop = devices is 'both' or devices is 'desktop'
    isMobile = devices is 'both' or devices is 'mobile'

    # images saved immediately (no need to hit 'next step')
    Game.updateById(@state().gameId, {
      description: @state().descriptionBlock.input.getValue()
      orientation: @state().orientationBlock.getChecked().getValue()
      isDesktop
      isMobile
    })
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert "Error: #{error.detail}"
      throw err

  render: (
    {
      gameId
      categoryBlock
      descriptionBlock
      orientationBlock
      devicesBlock
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
    # TODO (Austin): remove key when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-details', {key: 1},
      z 'form.form', {
        onsubmit: (e) =>
          e?.preventDefault()

          @save().then ->
            z.router.go "/developers/edit-game/upload/#{gameId}"
            .catch log.trace
        },

        categoryBlock
        descriptionBlock

        z 'h2.title', 'Supported Game Orientations'
        orientationBlock

        z 'h2.title', 'Supported Device Types'
        devicesBlock

        z 'hr'

        z 'h2.title',
          'Graphics '
          z 'i.icon.icon-help',
            title: 'We require a few images for your game to make sure it
            looks great and get more people playing.'

        iconUpload
        accentUpload
        headerUpload

        z 'h2.title',
          'Screenshots'
          z 'div.label-info',
            "#{config.SCREENSHOT_MIN_COUNT} required, minimum 320px dimension"

        # FIXME: ability to remove screenshots
        screenshotUpload1
        screenshotUpload2
        screenshotUpload3
        screenshotUpload4
        screenshotUpload5

        z 'div.next-step-container',
          z 'button.button-secondary.next-step',
            # FIXME: check that all images, etc... are uploaded
            unless true
              disabled: true
            ,
            'Next step'
