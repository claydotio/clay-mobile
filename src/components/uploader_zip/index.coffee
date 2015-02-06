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

  getDropzone$: =>
    z 'div.z-uploader-zip',
      # .dz-message necessary to be clickable (no workaround)
      z 'div.upload-dropzone.dz-message.l-flex.l-vertical-center',
        z 'div.upload-content',
          if @o_hasUploaded()
            [
              z 'div.green-check',
                z 'i.icon.icon-check'
              z 'h3.uploaded', 'Uploaded'
              z 'div.cache-warning',
                'Note that it may take a few hours for all game files to reflect
                your changes'
              z 'a[href=#].replace', 'replace'
            ]
          else
            [
              z 'i.icon.icon-cloud-upload'
              z 'div.drop-here', 'Drop your game .zip here'
              z 'a[href=#].browse', 'or browse'
            ]
