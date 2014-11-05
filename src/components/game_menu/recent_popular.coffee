z = require 'zorium'
_ = require 'lodash'

GameFilter = require '../../models/game_filter'

styles = require './recent_popular.styl'

module.exports = class GameMenu
  constructor: ->
    styles.use()

    @items = z.prop [
      {title: 'Recent', filter: 'recent', link: '/games/recent'},
      {title: 'Popular', filter: 'top', link: '/games/top'}
    ]

    # Select item based on filter
    filter = GameFilter.getFilter()
    for item in @items()
      if item.filter is filter
        item.isSelected = true

  render: =>
    z 'nav.game-menu', _.map @items(), (item) ->
      isSelected = if item.isSelected then '.is-selected' else ''

      z "a#{isSelected}[href='#{item.link}']",
        {config: z.route}, "#{item.title}"
