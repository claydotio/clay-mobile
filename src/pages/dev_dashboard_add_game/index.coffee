z = require 'zorium'

DevDashboardHeader = require '../../components/dev_dashboard_header'
DevDashboardAddGameMenu = require '../../components/dev_dashboard_add_game_menu'

module.exports = class DevDashboardAddGamePage
  constructor: ->
    @DevDashboardHeader = new DevDashboardHeader()
    @DevDashboardAddGameMenu = new DevDashboardAddGameMenu()

  render: =>
    z 'div',
      z 'div', @DevDashboardHeader
      z '.l-content-container.l-flex',
        z 'div', {style: width: '300px'}, @DevDashboardAddGameMenu
