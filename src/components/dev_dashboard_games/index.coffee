z = require 'zorium'
_ = require 'lodash'

User = require '../../models/user'
Developer = require '../../models/developer'

styles = require './index.styl'

module.exports = class DevDashboardGames
  constructor: ->
    styles.use()

    @state = z.state
      games: z.observe User.getDevelopers().then (developers) ->
        Developer.getGames developers[0].id

  render: ->
    z 'div.z-dev-dashboard-games',
    if @state().games
      z 'div.container',
        z 'h2.title', 'My games'
          z 'div.games',
            _.map @state().games, (game) ->
              z 'div.game-container',
                z 'div.game',
                  z '.image-content',
                    z '.image-background',
                      # FIXME use accent if available
                      style: backgroundImage: "url(#{game.promo440Url})"
                    z '.image-overlay',
                      z "img[src=#{game.icon128Url}]",
                        width: 70
                        height: 70
                      z '.image-text', game.name
                  z '.actions',
                    z 'span.status', 'Published'
                    z 'div.action-links',
                      z.router.a ".edit[href=/developers/edit-game/#{game.id}]",
                        z 'i.icon.icon-edit'
                        z 'span', 'Edit'
                      # TODO (Austin). Implement when someone asks for it
                      #z.router.a '.delete[href=#]',
                      #  z 'i.icon.icon-edit'
                      #  z 'span', 'Delete'
    else
      # FIXME: working links
      z 'div.container.no-games',
        z 'h1', 'Thanks for joining!'
        z 'h1', "We can't wait to play your awesome game!"
        z 'div', "If you're ready to publish your first game, that blue button
                  on the left is for you."
        z 'div', "If not, here's a couple handy links to help you get the most
                  out of Clay."

        z 'ul',
          z 'li',
            z.router.a '[href=github.com/claydotio/clay-sdk]',
              'Read the developer documentation'
          z 'li',
            z.router.a '[href=github.com/claydotio/clay-sdk]',
              'Integrate the Clay SDK'
          z 'li',
            z.router.a '[href=
            github.com/claydotio/design-assets/blob/master/design_style_guide.md
            ]',
              'Create beautiful promotional graphics'

        z 'h1', 'Have any questions? Let us help.'
        z 'ul',
          z 'li',
            z.router.a '[href=#]', 'Contact us'
