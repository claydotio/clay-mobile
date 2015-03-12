z = require 'zorium'
log = require 'clay-loglevel'

Game = require '../../models/game'
Spinner = require '../spinner'
UrlService = require '../../services/url'

styles = require './index.styl'

module.exports = class DevEditGameMenu
  constructor: ({currentStep}) ->
    styles.use()

    o_game = Game.getEditingGame()
    @state = z.state
      currentStep: currentStep
      game: o_game
      isLoading: false
      spinner: new Spinner()

  publish: =>
    @state.set isLoading: true
    Game.saveEditingGame()
    .then =>
      Game.updateById @state().game.id, status: 'Approved'
    .then =>
      @state.set isLoading: false
    .catch (err) =>
      @state.set isLoading: false
      throw err

  save: =>
    @state.set isLoading: true
    Game.saveEditingGame()
    .then =>
      @state.set isLoading: false
    .catch (err) =>
      @state.set isLoading: false
      throw err

  render: =>
    {currentStep, game, isLoading, spinner} = @state()

    isStartComplete = Game.isStartComplete game
    isDetailsComplete = Game.isDetailsComplete game
    isUploadComplete = Game.isUploadComplete game
    isApprovable = Game.isApprovable game
    gameUrl = UrlService.getGameSubdomain {game}

    menuSteps = [
      {
        step: 'start'
        text: 'Get started'
        isCompleted: isStartComplete
      }
      {
        step: 'details'
        text: 'Add details'
        isCompleted: isDetailsComplete
      }
      {
        step: 'upload'
        text: 'Upload game'
        isCompleted: isUploadComplete
      }
    ]

    z '.z-dev-edit-game-menu',
      z '.menu',
        z.router.link z 'a.menu-item[href=/dashboard]',
          z 'div.menu-item-content',
            z 'div.text', 'Back to dashboard'

      z '.menu',
        _.map menuSteps, ({step, text, isCompleted}) =>
          z "a.menu-item[href=/edit-game/#{step}/#{game?.id}]
          #{currentStep is step and '.is-selected'}
          #{isCompleted and '.is-completed'}", {
            onclick: (e) =>
              e?.preventDefault()
              @save().then ->
                z.router.go "/edit-game/#{step}/#{game?.id}"
              .catch (err) ->
                # TODO: (Austin) better error handling UX
                window.alert "Error: #{err.detail}"
              .catch log.trace
            },
            z 'div.l-flex.l-vertical-center.menu-item-content',
              z 'div.text', text
              z 'i.icon.icon-check'

      z '.menu',
        z "a.menu-item.test-game[href=#{gameUrl}][target=_blank]
        #{(not isUploadComplete or not game.key) and '.is-disabled'}",
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Test game'

        z "button.menu-item.publish
        #{not isApprovable and '[disabled]'}", {
          onclick: (e) =>
            e?.preventDefault()

            @publish().then ->
              z.router.go "/edit-game/published/#{game.id}"
            .catch (err) ->
              # TODO: (Austin) better error handling UX
              window.alert "Error: #{err.detail}"
            .catch log.trace
          },
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Publish'
            z 'i.icon.icon-arrow-right'

      if isLoading
        spinner
