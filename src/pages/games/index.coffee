z = require 'zorium'
log = require 'clay-loglevel'

Header = require '../../components/header'
RecentGames = require '../../components/recent_games'
PopularGames = require '../../components/popular_games'
User = require '../../models/user'

module.exports = class GamesPage
  constructor: ->
    @Header = new Header()
    @RecentGames = new RecentGames()

    @PopularGames = null
    User.getMe().then (user) =>
      hasRecentGames = user.links.recentGames
      if hasRecentGames
        @PopularGames = new PopularGames({featuredGameRow: 1})
      else
        @PopularGames = new PopularGames({featuredGameRow: 0})

      z.redraw()
    .catch log.trace

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @RecentGames
      z 'div', @PopularGames
    ]
