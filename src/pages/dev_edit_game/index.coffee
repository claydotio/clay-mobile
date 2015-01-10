z = require 'zorium'

User = require '../../models/user'
Developer = require '../../models/developer'
Game = require '../../models/game'
DevHeader = require '../../components/dev_header'
DevEditGameMenu = require '../../components/dev_edit_game_menu'
DevEditGameMenu = require '../../components/dev_edit_game_menu'
DevEditGameGetStarted = require '../../components/dev_edit_game_get_started'
DevEditGameDetails = require '../../components/dev_edit_game_details'
DevEditGameUpload = require '../../components/dev_edit_game_upload'
DevEditGamePublished = require '../../components/dev_edit_game_published'
DevFooter = require '../../components/dev_footer'
Spinner = require '../../components/spinner'

module.exports = class DevDashboardAddGamePage
  constructor: (params) ->
    @state = z.state
      step: params.step
      DevHeader: new DevHeader()
      DevGameMenu: new DevEditGameMenu {step: params.step}
      DevEditGameGetStarted: new DevEditGameGetStarted()
      DevEditGameDetails: new DevEditGameDetails()
      DevEditGameUpload: new DevEditGameUpload()
      DevEditGamePublished: new DevEditGamePublished()
      DevFooter: new DevFooter()
      Spinner: new Spinner()
      isLoading: true

    if params.gameId
      Game.setEditingGame(params.gameId)
      @state.set isLoading: false
    else
      User.getMe().then ({id}) =>
        Developer.find({ownerId: id}).then (developers) =>
          Game.create(developers[0].id).then (game) =>
            Game.setEditingGame(game.id).then =>
              @state.set isLoading: false

  render: =>
    z 'div',
      z 'div', @state().DevHeader
      z '.l-content-container',
        if @state().isLoading
          z 'div', {style: marginTop: '20px'}, @state().Spinner
        else
          z 'div.l-flex',
            if @state().step isnt 'published'
              z 'div', @state().DevGameMenu
            z 'div.l-flex-1',
              if @state().step is 'details' then @state().DevEditGameDetails
              else if @state().step is 'upload' then @state().DevEditGameUpload
              else if @state().step is 'published'
              then @state().DevEditGamePublished
              else @state().DevEditGameGetStarted
      @state().DevFooter
