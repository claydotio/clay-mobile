z = require 'zorium'

User = require '../../models/user'
Developer = require '../../models/developer'
Game = require '../../models/game'
DevHeader = require '../../components/dev_header'
DevEditGameMenu = require '../../components/dev_edit_game_menu'
DevEditGameGetStarted = require '../../components/dev_edit_game_get_started'
DevEditGameDetails = require '../../components/dev_edit_game_details'
DevEditGameUpload = require '../../components/dev_edit_game_upload'
DevEditGamePublished = require '../../components/dev_edit_game_published'
DevBottomPadding = require '../../components/dev_bottom_padding'
Spinner = require '../../components/spinner'

module.exports = class DevEditGame
  constructor: (params) ->
    if params.gameId
      gamePromise = Game.get(params.gameId).then (game) =>
        @state.set isLoading: false
        return game

      Game.setEditingGame gamePromise
    else
      # create a new game
      gamePromise = User.getMe().then ({id}) =>
        Developer.find({ownerId: id}).then (developers) =>
          if not _.isEmpty developers
            Game.create({developerId: developers?[0]?.id}).then (game) =>
              @state.set isLoading: false
              return game
          else
            throw new Error 'Developer not found'
      Game.setEditingGame gamePromise

    @state = z.state
      currentStep: params.currentStep
      spinner: new Spinner()
      isLoading: true
      $devHeader: new DevHeader()
      $devGameMenu: new DevEditGameMenu {currentStep: params.currentStep}
      $devEditGameGetStarted: new DevEditGameGetStarted()
      $devEditGameDetails: new DevEditGameDetails()
      $devEditGameUpload: new DevEditGameUpload()
      $devEditGamePublished: new DevEditGamePublished()
      $devBottomPadding: new DevBottomPadding()

  render: =>
    {
      $devHeader
      $devGameMenu
      isLoading
      spinner
      currentStep
      $devEditGameGetStarted
      $devEditGameDetails
      $devEditGameUpload
      $devEditGamePublished
      $devBottomPadding
    } = @state()

    z 'div',
      z 'div',
        z $devHeader, currentPage: 'dashboard'
      z '.l-content-container',
        z 'div.l-flex',
          if currentStep isnt 'published'
            z 'div', $devGameMenu
          if isLoading
            z 'div.l-flex-1', {style: marginTop: '20px'}, spinner
          else
            z 'div.l-flex-1',
              if currentStep is 'details' then $devEditGameDetails
              else if currentStep is 'upload' then $devEditGameUpload
              else if currentStep is 'published'
              then $devEditGamePublished
              else $devEditGameGetStarted
      z 'div', $devBottomPadding
