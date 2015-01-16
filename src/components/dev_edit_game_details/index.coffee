z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
Game = require '../../models/game'
User = require '../../models/user'
UploaderImage = require '../uploader_image'
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
  {isDesktop, isMobile}

module.exports = class DevEditGameDetails
  constructor: ->
    styles.use()

    o_game = Game.getEditingGame()

    o_iconImage = z.observe o_game.then (game) -> game.iconImage
    o_iconImage (iconImage) ->
      Game.updateEditingGame iconImage: iconImage
    o_headerImage = z.observe o_game.then (game) -> game.headerImage
    o_headerImage (val) ->
      Game.updateEditingGame headerImage: val
    o_category = z.observe o_game.then (game) -> game.category or 'action'
    o_category (val) ->
      Game.updateEditingGame category: val
    o_description = z.observe o_game.then (game) -> game.description
    o_description (val) ->
      Game.updateEditingGame description: val
    o_devices = z.observe o_game.then (game) ->
      getDeviceStringFromBooleans game.isDesktop, game.isMobile
    o_devices (val) ->
      {isDesktop, isMobile} = getDeviceBooleansFromString val
      Game.updateEditingGame {isDesktop, isMobile}
    o_orientation = z.observe o_game.then (game) -> game.orientation or 'both'
    o_orientation (val) ->
      Game.updateEditingGame orientation: val

    # TODO: (Austin) when observable properly supports arrays, use an array here
    o_screenshotImages = z.observe _.reduce _.range(5), (images, image, i) ->
      images[i] = z.observe o_game.then (game) -> game.screenshotImages[i]
      return images
    , {}

    o_screenshotImages (val) ->
      unless o_game()
        return
      screenshotImages = _.filter val
      # need to save this instantly since we have cap # of screenshots
      Game.updateById o_game().id, {
        links:
          screenshotImages: screenshotImages
      }
      Game.updateEditingGame {screenshotImages}



    @state = z.state
      game: o_game
      iconUpload: z.observe o_game.then (game) ->
        User.getMe().then ({accessToken}) ->
          new UploaderImage {
            url: "#{config.CLAY_API_URL}/games/#{game.id}/" +
                  "links/iconImage?accessToken=#{accessToken}"
            inputName: 'image'
            o_uploadedObj: o_iconImage
            label: 'Icon'
            height: 110
            loadingCircleDiameter: 80
            sourceWidth: 512
            sourceHeight: 512
          }
      headerUpload: z.observe o_game.then (game) ->
        User.getMe().then ({accessToken}) ->
          new UploaderImage {
            url: "#{config.CLAY_API_URL}/games/#{game.id}/" +
                  "links/headerImage?accessToken=#{accessToken}"
            inputName: 'image'
            o_uploadedObj: o_headerImage
            label: 'Header'
            height: 110
            loadingCircleDiameter: 80
            sourceWidth: 2550
            sourceHeight: 850
            sourceSafeWidth: 1700
            sourceSafeHeight: 850
          }
      screenshots: z.observe Promise.all([
        o_screenshotImages, o_game, User.getMe()
      ]).then ([screenshots, game, {accessToken}]) ->
        _.map _.range(5), (i) ->
          new UploaderImage {
            url: "#{config.CLAY_API_URL}/games/#{game.id}/" +
                  "links/screenshotImages?accessToken=#{accessToken}"
            method: 'post'
            inputName: 'image'
            o_uploadedObj: o_screenshotImages[i]
            height: 110
            loadingCircleDiameter: 80
            sourceWidth: 320
            sourceHeight: 320
          }
      categoryInput: new InputSelect {
        label: 'Category'
        o_value: o_category
        options: [
          {label: 'Action', value: 'action'}
          {label: 'Adventure', value: 'adventure'}
          {label: 'Arcade', value: 'arcade'}
          {label: 'Puzzle', value: 'puzzle'}
          {label: 'Racing', value: 'racing'}
          {label: 'Stategy', value: 'strategy'}
        ]
      }
      descriptionInput: new InputTextarea {
        label: 'Description'
        o_value: o_description
      }
      orientationInput: new InputRadios {
        o_value: o_orientation
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
      }
      devicesInput: new InputRadios {
        o_value: o_devices
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
      }

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
        onsubmit: (e) ->
          e?.preventDefault()

          Game.updateById(game.id, game).then ->
            z.router.go "/developers/edit-game/upload/#{game.id}"
          .catch (err) ->
            log.trace err
            error = JSON.parse err._body
            # TODO: (Austin) better error handling UX
            alert "Error: #{error.detail}"
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
            onclick: (e) -> alert e.target.title

        z 'div.uploader-container', iconUpload
        z 'div.uploader-container', headerUpload

        z 'h2.title',
          'Screenshots'
          z 'div.label-info',
            "#{config.SCREENSHOT_MIN_COUNT} required, minimum 320px dimension"

        _.map screenshots, (screenshot) ->
          z 'div.uploader-container', screenshot

        z 'div.next-step-container',
          z 'button.button-secondary.next-step',
            unless Game.isDetailsComplete game
              disabled: true
            ,
            'Next step'
