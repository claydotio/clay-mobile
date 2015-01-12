z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'
Dropzone = require 'dropzone'

ZipUploader = require '../zip_uploader'
InputText = require '../input_text'

styles = require './index.styl'

module.exports = class DevEditGameUpload
  constructor: ->
    styles.use()

    @state = z.state
      zipUpload: new ZipUploader()
      externalHostInput: new InputText {
        placeholder: 'http://yourcoolgame.com'
        theme: '.theme-medium-width'
      }

  onBeforeUnmount: =>
    @save()
    .catch log.trace

  save: =>
    externalHostPath = @state().externalHostInput.getValue()
    if externalHostPath
      Game.updateById(@state().gameId, {
        path: externalHostPath
      })
      .catch (err) ->
        log.trace err
        error = JSON.parse err._body
        # TODO: (Austin) better error handling UX
        alert error.detail
        throw err
    else
      Promise.resolve(null)

  render: ({zipUpload, externalHostInput}) ->
    # TODO (Austin): remove when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-upload.l-flex', {key: 3},
        z 'form.form',
          # .dz-message necessary to be clickable (no workaround)
          zipUpload

          z 'label.external-host',
            z 'div.label-text', 'Game hosted elsewhere? Enter the URL:'
            externalHostInput

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
