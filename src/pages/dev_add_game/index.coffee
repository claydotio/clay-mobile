z = require 'zorium'

Game = require '../../models/game'
DevHeader = require '../../components/dev_header'
DevAddGameMenu = require '../../components/dev_add_game_menu'
DevEditGameMenu = require '../../components/dev_edit_game_menu'
DevAddGameGetStarted = require '../../components/dev_add_game_get_started'
DevAddGameDetails = require '../../components/dev_add_game_details'
DevAddGameUpload = require '../../components/dev_add_game_upload'
DevAddGamePublished = require '../../components/dev_add_game_published'

module.exports = class DevDashboardAddGamePage
  constructor: (params) ->
    if params.gameId
      Game.setEditingGame params.gameId

    @state = z.state
      step: params.step
      DevHeader: new DevHeader()
      DevGameMenu:
        if params.gameId
        then new DevEditGameMenu({step: params.step, gameId: params.gameId})
        else new DevAddGameMenu({step: params.step})
      DevAddGameGetStarted: new DevAddGameGetStarted()
      DevAddGameDetails: new DevAddGameDetails()
      DevAddGameUpload: new DevAddGameUpload()
      DevAddGamePublished: new DevAddGamePublished()

  render: =>
    z 'div',
      z 'div', @state().DevHeader
      z '.l-content-container.l-flex',
        if @state().step isnt 'published'
          z 'div', {style: width: '240px'}, @state().DevGameMenu
        z 'div.l-flex-1',
          if @state().step is 'details' then @state().DevAddGameDetails
          else if @state().step is 'upload' then @state().DevAddGameUpload
          else if @state().step is 'published' then @state().DevAddGamePublished
          else @state().DevAddGameGetStarted
