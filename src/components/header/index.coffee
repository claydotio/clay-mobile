z = require 'zorium'

require './index.styl'

module.exports = class Header
  render: ->
    z 'header.header', [
      z 'a.header-logo[href=/]', {config: z.route}
    ]
