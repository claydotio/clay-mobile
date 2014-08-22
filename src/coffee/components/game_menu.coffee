z = require 'zorium'
_ = require 'lodash'

module.exports = class GameMenu
  constructor: ->
    @items = z.prop [
      {title: 'Popular', link: '/', isSelected: true},
      {title: 'New Games', link: '/'}
    ]
  render: =>
    z 'nav.game-menu', _.map @items(), (item) ->
      isSelected = if item.isSelected then '.isSelected' else ''

      z "a#{isSelected}[href='#{item.link}']",
        {config: z.route}, "#{item.title}"
