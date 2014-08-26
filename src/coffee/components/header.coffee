z = require 'zorium'

module.exports = class Header
  render: ->
    z 'header.header', [
      z 'a.header-logo[href=/]', {config: z.route}, [
        z 'img', src: '//cdn.wtf/d/images/logos/logo.svg'
      ]
    ]
