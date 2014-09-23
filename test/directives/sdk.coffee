_ = require 'lodash'
should = require('clay-chai').should()

SDKDir = require 'directives/sdk'

directive = new SDKDir()

describe 'SDKDir', ->
  it 'pongs', ->
    # $el = document.createElement 'div'
    # ctx = {onunload: _.noop}
    # directive.config $el, false, ctx
    #
    # event = new Event 'message'
    # event.data = JSON.stringify {}
    # event.source = {
    #   postMessage: ->
    #     console.log 'successs'
    # }
    # window.dispatchEvent ev

    null
