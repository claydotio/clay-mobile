z = require 'zorium'

module.exports = class Nav
  render: ->
    z 'nav.nav', [
      z 'a[href=/]', 'Top'
      z '.separator'
      z 'a[href=/games/new]', 'New'
    ]
