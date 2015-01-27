z = require 'zorium'
_ = require 'lodash'

User = require '../../models/user'
Developer = require '../../models/developer'
Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevDashboardGames
  constructor: ->
    styles.use()

    @state = z.state
      games: z.observe(
        User.getMe().then ({id}) ->
          Developer.find({ownerId: id}).then (developers) ->
            if not _.isEmpty developers
              Game.find({developerId: developers[0].id})
            else
              throw new Error 'Developer not found'
      )

  render: ({games}) ->
    z 'div.z-dev-dashboard-games',
    if not _.isEmpty games
      z 'div.container',
        z 'h2.title', 'My games'
          z 'div.games',
            _.map games, (game) ->
              z 'div.game-container',
                z 'div.game',
                  z '.image-content',
                    z '.image-background',
                      style:
                        backgroundImage: if game.headerImage
                        then "url(#{game.headerImage.versions[0].url})"
                        else 'none'
                    z '.image-overlay',
                      z 'img',
                        src: if game.iconImage \
                        then game.iconImage.versions[0].url
                        else ''
                        width: 70
                        height: 70
                      z '.image-text', game.name
                  z '.actions',
                    z 'span.status', game.status
                    z 'div.action-links',
                      z.router.link z "a.edit[href=
                                      /edit-game/start/#{game.id}]",
                        z 'i.icon.icon-edit'
                        z 'span', 'Edit'

    else if games isnt null # null = still loading
      z 'div.container.no-games',
        z 'h1', 'Thanks for joining!'
        z 'h1', "We can't wait to play your awesome game!"
        z 'div', "If you're ready to publish your first game, that blue button
                  on the left is for you."
        z 'div', "If not, here's a couple handy links to help you get the most
                  out of Clay."

        z 'ul',
          z 'li',
            z 'a[target=_blank][href=https://github.com/claydotio/clay-sdk]',
              'Read the developer documentation'
          z 'li',
            z 'a[target=_blank][href=https://github.com/claydotio/clay-sdk]',
              'Integrate the Clay SDK'
          z 'li',
            z 'a[target=_blank][href=https://github.com' +
              '/claydotio/design-assets/blob/master/design_style_guide.md]',
              'Create beautiful promotional graphics'

        z 'h1', 'Have any questions? Let us help.'
        z 'ul',
          z 'li',
            z.router.link z 'a[href=/dashboard/contact]', 'Contact us'
