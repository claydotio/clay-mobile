z = require 'zorium'

styles = require './index.styl'

module.exports = class Nub
  constructor: ({@toggleCallback}) ->
    styles.use()

  render: =>
    z 'div.z-nub', ontouchstart: @toggleCallback,
      z 'i.icon.icon-menu'
