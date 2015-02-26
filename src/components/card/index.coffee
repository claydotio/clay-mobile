z = require 'zorium'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Card
  constructor: ->
    styles.use()

  render: ({content, colors}) ->
    content ?= ''
    colors ?= {}
    colors = _.defaults colors, {
      c500: styleConfig.$white
      ink: styleConfig.$grey900
    }

    z '.z-card', {
      style:
        backgroundColor: colors.c500
        color: colors.ink
    },
      z '.content', content
