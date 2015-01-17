z = require 'zorium'
_ = require 'lodash'

UploaderBase = require '../uploader_base'

styles = require './index.styl'

module.exports = class UploaderImage extends UploaderBase
  constructor: ({
    label
    width
    height
    sourceWidth
    sourceHeight
    sourceSafeWidth
    sourceSafeHeight
  }) ->
    styles.use()

    super

    label ?= ''
    sourceSafeWidth ?= sourceWidth
    sourceSafeHeight ?= sourceHeight
    # scaled per design specs, not full-size images
    renderScale = height / sourceHeight
    width ?= sourceWidth * renderScale
    hasSafeConstraint = sourceSafeWidth isnt sourceWidth or
                        sourceSafeHeight isnt sourceHeight
    safeWidth = sourceSafeWidth * renderScale
    safeHeight = sourceSafeHeight * renderScale

    @state.set {
      thumbnail: null
      acceptedFileTypes: 'image/jpeg,image/png'
      label
      width
      sourceSafeWidth
      sourceSafeHeight
      safeWidth
      safeHeight
      hasSafeConstraint
    }

  getDropzone$: =>
    {
      isLoading
      percentUploaded
      label
      thumbnail
      width
      height
      hasSafeConstraint
      safeWidth
      safeHeight
    } = @state()

    thumbnail ?= @o_uploadedObj()?.versions?[0]?.url

    z "div.z-uploader-image#{if isLoading then '.is-loading' else ''}",
      # .dz-message necessary to be clickable (no workaround)
      z 'div.dz-message.clickable.l-flex.l-vertical-center',
        z 'div.content.percentage',
          "#{percentUploaded}%"
        z 'div.content.drop-here',
          z 'div', '+'
          z 'div', label
          z 'div', 'Drop here'

      if thumbnail # FIXME
        z 'div.thumbnail',
          z 'a.close[href=#]',
            onclick: (e) =>
              e.preventDefault()
              @o_uploadedObj.set null
              @state.set thumbnail: ''
            z 'i.icon.icon-close'
          z "img[src=#{thumbnail}]"
          if hasSafeConstraint
            z 'div.safe-unsafe',
              z 'div.unsafe-overlay'
              z 'div.safe',
                {
                  style:
                    width: "#{safeWidth}px"
                    height: "#{safeHeight}px"
                    left: '50%'
                    marginLeft: -1 * safeWidth / 2 + 'px'
                    top: '50%'
                    marginTop: -1 * safeHeight / 2 + 'px'
                },
                z 'div.safe-text', 'Safe zone'
                z "img[src=#{thumbnail}]",
                  {
                    style:
                      width: "#{width}px"
                      marginLeft: -1 * (width - safeWidth) /
                        2 + 'px'
                      marginTop: -1 * (height - safeHeight) /
                        2 + 'px'
                  }
