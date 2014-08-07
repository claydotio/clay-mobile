z = require 'zorium'

module.exports = class NavView
  render: ->
    z 'nav.nav', [
      z 'a', 'Categories'
      z '.separator'
      z 'a', 'Top'
    ]
