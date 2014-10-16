z = require 'zorium'
_ = require 'lodash'

Navigation = require '../models/navigation'

module.exports = class Menu
  constructor: ->
    @items = z.prop [
      {title: 'Meet', route: '/meet', page: 'meet'},
      {title: 'Games', link: '/games', page: 'games'}
    ]

    # Select menu item based on page
    page = Navigation.getPage()
    for item in @items()
      if item.page == page
        item.isSelected = true

  render: =>
    z 'nav.game-menu', _.map @items(), (item) ->
      isSelected = if item.isSelected then '.is-selected' else ''

      z "a#{isSelected}[href='#{item.link}']",
        {config: z.route}, "#{item.title}"
