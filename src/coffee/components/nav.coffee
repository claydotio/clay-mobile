z = require 'zorium'

module.exports = class Nav
  render: ->
    z 'nav.nav', [
      z 'a', 'Categories'
      z '.separator'
      z 'a', 'Top'
    ]
