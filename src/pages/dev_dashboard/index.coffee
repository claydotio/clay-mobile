z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardContact = require '../../components/dev_dashboard_contact'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevDashboardMenu = require '../../components/dev_dashboard_menu'
DevFooter = require '../../components/dev_footer'

module.exports = class DevDashboard
  constructor: (params) ->
    @state = z.state
      DevHeader: new DevHeader()
      DevDashboardMenu: new DevDashboardMenu({tab: params.tab})
      DevDashboardContact: new DevDashboardContact()
      DevDashboardGames: new DevDashboardGames()
      DevFooter: new DevFooter()
      tab: params.tab

  render: (
    {
      DevHeader
      DevDashboardMenu
      DevDashboardContact
      DevDashboardGames
      DevFooter
      tab
    }
  ) ->
    z 'div',
      z 'div', DevHeader
      z '.l-content-container.l-flex',
        z 'div', DevDashboardMenu
        z 'div.l-flex-1',
          if tab is 'contact' then DevDashboardContact
          else DevDashboardGames
      DevFooter
