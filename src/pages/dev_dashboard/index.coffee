z = require 'zorium'

DevHeader = require '../../components/dev_header'
DevDashboardMenu = require '../../components/dev_dashboard_menu'
Contact = require '../../components/contact'
DevDashboardGames = require '../../components/dev_dashboard_games'
DevBottomPadding = require '../../components/dev_bottom_padding'

module.exports = class DevDashboard
  constructor: ({tab}) ->
    @state = z.state
      $devHeader: new DevHeader()
      $devDashboardMenu: new DevDashboardMenu({selected: tab})
      $devDashboardContact: new DevDashboardContact()
      $devDashboardGames: new DevDashboardGames()
      $devBottomPadding: new DevBottomPadding()
      selectedTab: tab

  render: =>
    {
      $devHeader
      $devDashboardMenu
      $devDashboardContact
      $devDashboardGames
      $devBottomPadding
      selectedTab
    } = @state()

    z 'div',
      z 'div',
        z $devHeader, currentPage: 'dashboard'
      z '.l-content-container.l-flex',
        z 'div', $devDashboardMenu
        z 'div.l-flex-1',
          if selectedTab is 'contact' then $devDashboardContact
          else $devDashboardGames
      z 'div', $devBottomPadding
