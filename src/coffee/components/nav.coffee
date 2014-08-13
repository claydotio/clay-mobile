z = require 'zorium'

module.exports = class Nav
  render: ->
    z 'nav.nav', [
      z 'a[href="/"]', {config: z.route}, 'Top'
      z '.separator'
      z 'a[href="/games/new/"]', {config: z.route}, 'New'
    ]
