z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

config = require '../../config'
UploaderZip = require '../uploader_zip'
InputText = require '../input_text'
Game = require '../../models/game'
User = require '../../models/user'

styles = require './index.styl'

module.exports = class DevEditGameUpload
  constructor: ->
    styles.use()

    o_game = Game.getEditingGame()

    o_hasUploaded = z.observe false
    o_hasUploaded (hasUploaded) ->
      if hasUploaded
        Game.setEditingGame Game.get(o_game().id)

    @state = z.state
      zipUpload: z.observe o_game.then (game) ->
        User.getMe().then ({accessToken}) ->
          new UploaderZip {
            url: "#{config.CLAY_API_URL}/games/#{game.id}/" +
                 "zip?accessToken=#{accessToken}"
            inputName: 'zip'
            width: 320
            height: 320
            o_hasUploaded: o_hasUploaded
          }

  render: ({zipUpload}) ->
    # TODO (Austin): remove when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-upload.l-flex', {key: 3},
        z 'form.form',
          zipUpload
          z '.reminder',
            z '.warn', 'REMINDER'
            z 'span', 'Integration of the SDK is required'
            z '.forgot', 'Don\'t worry, it just takes a minute.'
            z 'a.button-secondary.add-now[target=_blank]
                [href=https://github.com/claydotio/clay-sdk]',
              'Add it now'

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
