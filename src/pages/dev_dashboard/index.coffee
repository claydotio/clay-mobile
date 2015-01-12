z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardMenu = require '../../components/dev_dashboard_menu'
DevDashboardContact = require '../../components/dev_dashboard_contact'
DevDashboardGames = require '../../components/dev_dashboard_games'

module.exports = class DevDashboard
  constructor: (params) ->
    @state = z.state
      DevHeader: new DevHeader(currentPage: 'dashboard')
      DevDashboardMenu: new DevDashboardMenu({selected: params.tab})
      DevDashboardContact: new DevDashboardContact()
      DevDashboardGames: new DevDashboardGames()
      selectedTab: params.tab

  render: (
    {
      DevHeader
      DevDashboardMenu
      DevDashboardContact
      DevDashboardGames
      selectedTab
    }
  ) ->
    z 'div.l-dev-page-container',
      z 'div', DevHeader
      z '.l-content-container.l-flex',
        z 'div', DevDashboardMenu
        z 'div.l-flex-1',
          if selectedTab is 'contact' then DevDashboardContact
          else DevDashboardGames
