z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'
Dropzone = require 'dropzone'

config = require '../../config'
ZipUploader = require '../zip_uploader'
InputText = require '../input_text'
Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevEditGameUpload
  constructor: ->
    styles.use()

    @state = z.state
      gameId: null
      zipUpload: null

    Game.getEditingGame().then (game) =>
      @state.set
        gameId: game.id
        zipUpload: new ZipUploader {
          url: "#{config.CLAY_API_URL}/games/#{game.id}/zip"
          inputName: 'zip'
          onchange: (isSet) ->
            Game.updateEditingGame gameUrl: isSet
            .catch log.trace
        }

  render: ({zipUpload, externalHostInput}) ->
    # TODO (Austin): remove when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-upload.l-flex', {key: 3},
        z 'form.form',
          # .dz-message necessary to be clickable (no workaround)
          zipUpload

        z 'div.help.l-flex-right',
          z 'h1',
            'What do I upload?'
          z 'div.what-to-upload', 'index.html and all assets'
          z 'div.icon-block',
            z 'i.icon.icon-dev-console'
            z 'i.icon.icon-photos'
            z 'i.icon.icon-music'
          z 'div.icon-block',
            z 'i.icon.icon-arrow-down'
          z 'div.icon-block',
            z 'i.icon.icon-zipped'
          z 'div.what-to-upload', 'zipped all together'
