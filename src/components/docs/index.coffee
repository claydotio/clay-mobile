z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'

styles = require './index.styl'

module.exports = class Docs
  constructor: ->
    styles.use()

  render: ->
    z '.z-docs.l-content-container',
      z 'a', {
        href: 'https://github.com/claydotio/clay-sdk'
        target: '_blank'
      },
        'Find our SDK docs on GitHub!'
