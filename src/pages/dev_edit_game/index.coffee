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
Spinner = require '../../components/spinner'

module.exports = class DevEditGame
  constructor: (params) ->
    @state = z.state
      step: params.step
      DevHeader: new DevHeader(currentPage: 'dashboard')
      Spinner: new Spinner()
      isLoading: true

    if params.gameId
      gamePromise = Game.get(params.gameId).then (game) =>
        @state.set isLoading: false
        return game
      # FIXME: implement game component saves somewhere other than
      # onBeforeUnmount. Once that's done, remove this check. editingGame is
      # set to null here before the onBeforeUnmount, causing the save to fail
      # also remove in models/game.coffee
      if Game.getEditingGameId() isnt params.gameId
        Game.setEditingGameId params.gameId
        Game.setEditingGame gamePromise
    else
      # create a new game
      gamePromise = User.getMe().then ({id}) =>
        Developer.find({ownerId: id}).then (developers) =>
          Game.create(developers?[0].id).then (game) =>
            Game.setEditingGameId game.id
            @state.set isLoading: false
            return game
      Game.setEditingGame gamePromise

    @state.set
      DevGameMenu: new DevEditGameMenu {step: params.step}
      DevEditGameGetStarted: new DevEditGameGetStarted()
      DevEditGameDetails: new DevEditGameDetails()
      DevEditGameUpload: new DevEditGameUpload()
      DevEditGamePublished: new DevEditGamePublished()


  render: =>
    z 'div.l-dev-page-container',
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
