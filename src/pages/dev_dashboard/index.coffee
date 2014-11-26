z = require 'zorium'

DevDashboardHeader = require '../../components/dev_dashboard_header'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevDashboardMenu = require '../../components/dev_dashboard_menu'

module.exports = class DevDashboardPage
  constructor: ->
    @DevDashboardHeader = new DevDashboardHeader()
    @DevDashboardGames = new DevDashboardGames()
    @DevDashboardMenu = new DevDashboardMenu()

  render: =>
    z 'div',
      z 'div', @DevDashboardHeader
      z '.l-content-container.l-flex',
        z 'div', {style: width: '300px'}, @DevDashboardMenu
        z 'div.l-flex-1', @DevDashboardGames
