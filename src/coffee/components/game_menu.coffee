z = require 'zorium'

module.exports = class GameMenu
  render: ->
    z 'nav.game-menu', [
      z 'a[href="/"]', {config: z.route}, 'Top'
      z '.separator'
      z 'a[href="/games/new/"]', {config: z.route}, 'New'
    ]
