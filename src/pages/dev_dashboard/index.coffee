z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardMenu = require '../../components/dev_dashboard_menu'
DevDashboardContact = require '../../components/dev_dashboard_contact'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevBottomPadding = require '../../components/dev_bottom_padding'

module.exports = class DevDashboard
  constructor: (params) ->
    @state = z.state
      devHeader: new DevHeader(currentPage: 'dashboard')
      devDashboardMenu: new DevDashboardMenu({selected: params.tab})
      devDashboardContact: new DevDashboardContact()
      devDashboardGames: new DevDashboardGames()
      devBottomPadding: new DevBottomPadding()
      selectedTab: params.tab

  render: (
    {
      devHeader
      devDashboardMenu
      devDashboardContact
      devDashboardGames
      devBottomPadding
      selectedTab
    }
  ) ->
    z 'div',
      z 'div', devHeader
      z '.l-content-container.l-flex',
        z 'div', devDashboardMenu
        z 'div.l-flex-1',
          if selectedTab is 'contact' then devDashboardContact
          else devDashboardGames
      z 'div', devBottomPadding
