z = require 'zorium'
log = require 'clay-loglevel'

Game = require '../../models/game'
Spinner = require '../spinner'

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

  render: ({currentStep, game, isLoading, spinner}) =>
    isStartComplete = Game.isStartComplete game
    isDetailsComplete = Game.isDetailsComplete game
    isUploadComplete = Game.isUploadComplete game
    isApprovable = Game.isApprovable game

    z '.z-dev-edit-game-menu',
      z '.menu',
        z.router.link z 'a.menu-item[href=/dashboard]',
          z 'div.menu-item-content',
            z 'div.text', 'Back to dashboard'

      z '.menu',
        z "a.menu-item[href=/edit-game/start/#{game?.id}]
        #{if currentStep is 'start' then '.is-selected' else ''}
        #{if isStartComplete then '.is-completed' else ''}", {
          onclick: (e) =>
            e?.preventDefault()
            @save().then ->
              z.router.go "/edit-game/start/#{game?.id}"
            .catch (err) ->
              error = JSON.parse err._body
              # TODO: (Austin) better error handling UX
              window.alert "Error: #{error.detail}"
            .catch log.trace
          },
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Get started'
            z 'i.icon.icon-check'
        z "a.menu-item[href=/edit-game/details/#{game?.id}]
        #{if currentStep is 'details' then '.is-selected' else ''}
        #{if isDetailsComplete then '.is-completed' else ''}", {
          onclick: (e) =>
            e?.preventDefault()

            @save().then ->
              z.router.go "/edit-game/details/#{game?.id}"
            .catch (err) ->
              error = JSON.parse err._body
              # TODO: (Austin) better error handling UX
              window.alert "Error: #{error.detail}"
            .catch log.trace
          },
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Add details'
            z 'i.icon.icon-check'
        z "a.menu-item  [href=/edit-game/upload/#{game?.id}]
        #{if currentStep is 'upload' then '.is-selected' else ''}
        #{if isUploadComplete then '.is-completed' else ''}", {
          onclick: (e) =>
            e?.preventDefault()

            @save().then ->
              z.router.go "/edit-game/upload/#{game?.id}"
            .catch (err) ->
              error = JSON.parse err._body
              # TODO: (Austin) better error handling UX
              window.alert "Error: #{error.detail}"
            .catch log.trace
          },
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Upload game'
            z 'i.icon.icon-check'


      z '.menu',
        z "button.menu-item.publish
        #{if not isApprovable then '[disabled]' else ''}", {
          onclick: (e) =>
            e?.preventDefault()

            @publish().then ->
              z.router.go "/edit-game/published/#{game.id}"
            .catch (err) ->
              error = JSON.parse err._body
              # TODO: (Austin) better error handling UX
              window.alert "Error: #{error.detail}"
            .catch log.trace
          },
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Publish'
            z 'i.icon.icon-arrow-right'

      if isLoading
        spinner
