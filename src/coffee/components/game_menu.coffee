z = require 'zorium'
_ = require 'lodash'

GameFilter = require '../models/game_filter'

module.exports = class GameMenu
  constructor: ->
    @items = z.prop [
      {title: 'Popular', filter: 'top', link: '/'},
      {title: 'New games', filter: 'new', link: '/games/new'}
    ]

    # Select item based on filter
    filter = GameFilter.getFilter()
    for item in @items()
      if item.filter == filter
        item.isSelected = true

  render: =>
    z 'nav.game-menu', _.map @items(), (item) ->
      isSelected = if item.isSelected then '.is-selected' else ''

      z "a#{isSelected}[href='#{item.link}']",
        {config: z.route}, "#{item.title}"
