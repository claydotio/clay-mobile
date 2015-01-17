z = require 'zorium'
_ = require 'lodash'

UploaderBase = require '../uploader_base'

styles = require './index.styl'

module.exports = class UploaderZip extends UploaderBase
  constructor: ->
    styles.use()

    super

    @state.set acceptedFiles: 'application/zip,' +
                              'application/x-zip-compressed,' +
                              'application/octet-stream'

  getDropzone$: ->
    z 'div.z-uploader-zip',
      # .dz-message necessary to be clickable (no workaround)
      z 'div.upload-dropzone.dz-message.l-flex.l-vertical-center',
        z 'div.upload-content',
          z 'i.icon.icon-cloud-upload'
          z 'div.drop-here', 'Drop your game .zip here'
          z.router.link z 'a[href=#].browse', 'or browse'
