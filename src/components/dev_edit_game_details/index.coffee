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

getDeviceStringFromBooleans = (isDesktop, isMobile) ->
  if isMobile and isDesktop then 'both' \
  else if isMobile then 'mobile'
  else 'desktop'

getDeviceBooleansFromString = (stringDevice) ->
  isDesktop = stringDevice is 'both' or stringDevice is 'desktop'
  isMobile = stringDevice is 'both' or stringDevice is 'mobile'

module.exports = class DevEditGameDetails
  constructor: ->
    styles.use()

    gameObservable = Game.getEditingGame()

    @state = z.state
      game: gameObservable
      iconUpload: z.observe gameObservable.then (game) ->
        new ImageUploader {
          url: "#{config.CLAY_API_URL}/games/#{game.id}/iconImage"
          inputName: 'iconImage'
          thumbnail: game.iconImage
          label: 'Icon'
          renderHeight: 110
          width: 512
          height: 512
          onchange: (diff) ->
            Game.updateEditingGame diff
        }
      headerUpload: z.observe gameObservable.then (game) ->
        new ImageUploader {
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
        }
      screenshots: z.observe gameObservable.then (game) =>
        _.map _.range(0, 5), (i) =>
          new ImageUploader {
            url: "#{config.CLAY_API_URL}/games/#{game.id}/screenshotImages"
            method: 'post'
            inputName: 'screenshotImage'
            thumbnail: game.screenshotImages?[i]
            renderHeight: 110
            width: 320
            height: 320
            onchange: (diff) ->
              Game.updateEditingGame diff
            onremove: =>
              @removeScreenshot i
          }
      categoryInput: z.observe gameObservable.then (game) ->
        new InputSelect {
          label: 'Category'
          value: game.category
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
        }
      descriptionInput: z.observe gameObservable.then (game) ->
        new InputTextarea {
          label: 'Description'
          value: game.description
          onchange: (val) ->
            Game.updateEditingGame description: val
        }
      orientationInput: z.observe gameObservable.then (game) ->
        new InputRadios {
          hideLabel: true
          value: game.orientation or 'both'
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
            }
          onchange: (val) ->
            Game.updateEditingGame orientation: val
        }
      devicesInput: z.observe gameObservable.then (game) ->
        deviceString = getDeviceStringFromBooleans game.isDesktop, game.isMobile
        new InputRadios {
          hideLabel: true
          value: deviceString
          radios:
            desktop: {
              label: 'Desktop'
              name: 'devices'
              value: 'desktop'
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
          onchange: (val) ->
            {isDesktop, isMobile} = getDeviceBooleansFromString val
            Game.updateEditingGame {isDesktop, isMobile}
        }

    Game.getEditingGame() (game) =>
      if game
        _.map @state().screenshots, (screenshot, i) ->
          screenshot.setThumbnail(game.screenshotImages?[i] or '')


  onBeforeUnmount: =>
    @save()
    .catch log.trace

  removeScreenshot: (i) =>
    screenshotImages = @state().game.screenshotImages
    screenshotImages.splice i, 1
    Game.updateById @state().game.id, {screenshotImages}
    Game.updateEditingGame {screenshotImages}

  save: =>
    deviceString = @state().devicesInput.getValue()
    {isDesktop, isMobile} = getDeviceBooleansFromString deviceString

    # images saved immediately (no need to hit 'next step')
    Game.updateById(@state().game.id, {
      category: @state().categoryInput.getValue()
      description: @state().descriptionInput.getValue()
      orientation: @state().orientationInput.getValue()
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
      game
      categoryInput
      descriptionInput
      orientationInput
      devicesInput
      iconUpload
      headerUpload
      screenshots
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

        z 'div', categoryInput
        z 'div', descriptionInput

        z 'h2.title', 'Supported Game Orientations'
        z 'div', orientationInput

        z 'h2.title', 'Supported Device Types'
        z 'div', devicesInput

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

        z 'div', screenshots

        z 'div.next-step-container',
          z 'button.button-secondary.next-step',
            unless Game.isDetailsComplete game
              disabled: true
            ,
            'Next step'
