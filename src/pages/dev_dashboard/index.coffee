z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevDashboardMenu = require '../../components/dev_dashboard_menu'
DevDashboardFooter = require '../../components/dev_footer'

module.exports = class DevDashboardPage
  constructor: ->
    @DevHeader = new DevHeader()
    @DevDashboardGames = new DevDashboardGames()
    @DevDashboardMenu = new DevDashboardMenu()

  render: =>
    z 'div',
      z 'div', @DevHeader
      z '.l-content-container.l-flex',
        z 'div', {style: width: '240px'}, @DevDashboardMenu
        z 'div.l-flex-1', @DevDashboardGames
