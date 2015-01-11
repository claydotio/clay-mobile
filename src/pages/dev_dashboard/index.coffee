z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardContact = require '../../components/dev_dashboard_contact'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevDashboardMenu = require '../../components/dev_dashboard_menu'

module.exports = class DevDashboard
  constructor: (params) ->
    @state = z.state
      DevHeader: new DevHeader(currentPage: 'dashboard')
      DevDashboardMenu: new DevDashboardMenu({tab: params.tab})
      DevDashboardContact: new DevDashboardContact()
      DevDashboardGames: new DevDashboardGames()
      tab: params.tab

  render: (
    {
      DevHeader
      DevDashboardMenu
      DevDashboardContact
      DevDashboardGames
      tab
    }
  ) ->
    z 'div.l-dev-page-container',
      z 'div', DevHeader
      z '.l-content-container.l-flex',
        z 'div', DevDashboardMenu
        z 'div.l-flex-1',
          if tab is 'contact' then DevDashboardContact
          else DevDashboardGames
