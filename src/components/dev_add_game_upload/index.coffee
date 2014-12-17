z = require 'zorium'
_ = require 'lodash'
Dropzone = require 'dropzone'

DevZipUpload = require '../dev_zip_upload'

styles = require './index.styl'

module.exports = class DevAddGameUpload
  constructor: ->
    styles.use()

    @state = z.state
      zipUpload: new DevZipUpload()

  render: ->
    z 'div.z-dev-add-game-upload',
      z 'div.l-flex',
        z 'form',
          # .dz-message necessary to be clickable (no workaround)
          @state().zipUpload

          z 'label.external-host',
            'Game hosted elsewhere? Enter the URL:'
            z 'input[type=text][placeholder=http://yourcoolgame.com]'

        z 'div.l-flex-right',
          z 'div.help',
            z 'h1',
              'What do I upload?'
            z 'div.what-to-upload', 'index.html and all assets'
            z 'div',
              z 'i.icon.icon-dev-console'
              z 'i.icon.icon-photos'
              z 'i.icon.icon-music'
            z 'div',
              z 'i.icon.icon-arrow-down'
            z 'div',
              z 'i.icon.icon-zipped'
            z 'div.what-to-upload', 'zipped all together'
