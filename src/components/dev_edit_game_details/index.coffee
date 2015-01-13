z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
Game = require '../../models/game'
ImageUploader = require '../image_uploader'
InputRadios = require '../input_radios'
InputSelect = require '../input_select'
InputTextarea = require '../input_textarea'

styles = require './index.styl'

module.exports = class DevEditGameDetails
  constructor: ->
    styles.use()

    @state = z.state
      game: null
      iconUpload: null
      headerUpload: null
      screenshotUpload1: null
      screenshotUpload2: null
      screenshotUpload3: null
      screenshotUpload4: null
      screenshotUpload5: null
      categoryInput: new InputSelect {
        label: 'Category'
        options: [
          {label: 'Action', value: 'action'}
          {label: 'Adventure', value: 'adventure'}
          {label: 'Arcade', value: 'arcade'}
          {label: 'Puzzle', value: 'puzzle'}
          {label: 'Racing', value: 'racing'}
          {label: 'Stategy', value: 'strategy'}
        ]
        onchange: (val) ->
          Game.updateEditingGame category: val
          .catch log.trace
      }
      descriptionInput: new InputTextarea {
        label: 'Description'
        value: ''
        onchange: (val) ->
          Game.updateEditingGame description: val
          .catch log.trace
      }
      orientationInput: new InputRadios {
        hideLabel: true
        onchange: (val) ->
          Game.updateEditingGame orientation: val
          .catch log.trace
        radios:
          portrait: {
            label: 'Portrait'
            name: 'orientation'
            value: 'portrait'
          }
          landscape: {
            label: 'Landscape'
            name: 'orientation'
            value: 'landscape'
          }
          both: {
            label: 'Both'
            name: 'orientation'
            value: 'both'
            isChecked: true
          }
      }
      devicesInput: new InputRadios {
        hideLabel: true
        onchange: (val) ->
          isDesktop = val is 'both' or val is 'desktop'
          isMobile = val is 'both' or val is 'mobile'
          Game.updateEditingGame {isDesktop, isMobile}
          .catch log.trace
        radios:
          desktop: {
            label: 'Desktop'
            name: 'devices'
            value: 'desktop'
            isChecked: true
          }
          mobile: {
            label: 'Mobile'
            name: 'devices'
            value: 'mobile'
          }
          both: {
            label: 'Both'
            name: 'devices'
            value: 'both'
          }
      }

    Game.getEditingGame().then (game) =>
      @state.set
        game: game

      @setFormValues game
      @setImageUploaders game

    Game.getEditingGame() (game) =>
      if game
        @state.set game: game
        @state().screenshotUpload1.setThumbnail(game.screenshotImages?[0] or '')
        @state().screenshotUpload2.setThumbnail(game.screenshotImages?[1] or '')
        @state().screenshotUpload3.setThumbnail(game.screenshotImages?[2] or '')
        @state().screenshotUpload4.setThumbnail(game.screenshotImages?[3] or '')
        @state().screenshotUpload5.setThumbnail(game.screenshotImages?[4] or '')

  setFormValues: (game) =>
    @state().categoryInput.setValue game.category
    @state().descriptionInput.setValue game.description
    @state().orientationInput.setValue game.orientation

    deviceString = if game.isMobile and game.isDesktop then 'both'
    else if game.isMobile then 'mobile'
    else 'desktop'
    @state().devicesInput.setValue deviceString

  setImageUploaders: (game) =>
    @state.set
      iconUpload: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/iconImage"
        inputName: 'iconImage'
        thumbnail: game.iconImage
        label: 'Icon'
        renderHeight: 110
        width: 512
        height: 512
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
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
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
      )
      screenshotUpload1: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
        method: 'post'
        inputName: 'screenshotImage'
        thumbnail: game.screenshotImages?[0]
        renderHeight: 110
        width: 320
        height: 320
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
        onremove: =>
          screenshotImages = @state().game.screenshotImages
          screenshotImages.splice 0, 1
          Game.updateEditingGame {screenshotImages}
          Game.updateById @state().game.id, {screenshotImages}
      )
      screenshotUpload2: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
        method: 'post'
        inputName: 'screenshotImage'
        thumbnail: game.screenshotImages?[1]
        renderHeight: 110
        width: 320
        height: 320
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
        onremove: =>
          screenshotImages = @state().game.screenshotImages
          screenshotImages.splice 1, 1
          Game.updateEditingGame {screenshotImages}
          Game.updateById @state().game.id, {screenshotImages}
      )
      screenshotUpload3: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
        method: 'post'
        inputName: 'screenshotImage'
        thumbnail: game.screenshotImages?[2]
        renderHeight: 110
        width: 320
        height: 320
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
        onremove: =>
          screenshotImages = @state().game.screenshotImages
          screenshotImages.splice 2, 1
          Game.updateEditingGame {screenshotImages}
          Game.updateById @state().game.id, {screenshotImages}
      )
      screenshotUpload4: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
        method: 'post'
        inputName: 'screenshotImage'
        thumbnail: game.screenshotImages?[3]
        renderHeight: 110
        width: 320
        height: 320
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
        onremove: =>
          screenshotImages = @state().game.screenshotImages
          screenshotImages.splice 3, 1
          Game.updateEditingGame {screenshotImages}
          Game.updateById @state().game.id, {screenshotImages}
      )
      screenshotUpload5: new ImageUploader(
        url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
        method: 'post'
        inputName: 'screenshotImage'
        thumbnail: game.screenshotImages?[4]
        renderHeight: 110
        width: 320
        height: 320
        onchange: (diff) ->
          Game.updateEditingGame diff
          .catch log.trace
        onremove: =>
          screenshotImages = @state().game.screenshotImages
          screenshotImages.splice 4, 1
          Game.updateEditingGame {screenshotImages}
          Game.updateById @state().game.id, {screenshotImages}
      )

  onBeforeUnmount: =>
    @save()
    .catch log.trace

  save: =>
    devices = @state().devicesInput.getValue()
    isDesktop = devices is 'both' or devices is 'desktop'
    isMobile = devices is 'both' or devices is 'mobile'

    # images saved immediately (no need to hit 'next step')
    Game.updateById(@state().game.id, {
      category: @state().categoryInput.getValue()
      description: @state().descriptionInput.getValue()
      orientation: @state().orientationInput.getValue()
      isDesktop
      isMobile
    })
    .then Game.updateEditingGame
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert "Error: #{error.detail}"
      throw err

  render: (
    {
      game
      categoryInput
      descriptionInput
      orientationInput
      devicesInput
      iconUpload
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
            z.router.go "/developers/edit-game/upload/#{game.id}"
            .catch log.trace
        },

        categoryInput
        descriptionInput

        z 'h2.title', 'Supported Game Orientations'
        orientationInput

        z 'h2.title', 'Supported Device Types'
        devicesInput

        z 'hr'

        z 'h2.title',
          'Graphics '
          z 'i.icon.icon-help',
            title: 'We require a few images for your game to make sure it
            looks great and get more people playing.'

        iconUpload
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
            unless Game.isDetailsComplete game
              disabled: true
            ,
            'Next step'
