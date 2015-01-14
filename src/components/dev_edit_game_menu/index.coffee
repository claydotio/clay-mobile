z = require 'zorium'
log = require 'clay-loglevel'

Game = require '../../models/game'

styles = require './index.styl'

module.exports = class DevEditGameMenu
  constructor: ({step}) ->
    styles.use()

    gamePromise = Game.getEditingGame()
    @state = z.state {step, game: gamePromise}

  publish: (e) =>
    e?.preventDefault()

    Game.updateById(@state().game.id, {
      status: 'Approved'
    })
    .then =>
      z.router.go "/developers/edit-game/published/#{@state().game.id}"
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert "Error: #{error.detail}"
    .catch log.trace

  render: ({step, game}) ->
    isStartComplete = Game.isStartComplete game
    isDetailsComplete = Game.isDetailsComplete game
    isUploadComplete = Game.isUploadComplete game
    isApprovable = Game.isApprovable game

    z '.z-dev-edit-game-menu',
      z '.menu',
        z.router.link z 'a.menu-item[href=/developers]',
          z 'div.menu-item-content',
            z 'div.text', 'Back to dashboard'

      z '.menu',
        z.router.link z "a.menu-item
          [href=/developers/edit-game/start/#{game?.id}]
          #{if step is 'start' then '.is-selected' else ''}
          #{if isStartComplete then '.is-completed' else ''}",
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Get started'
            z 'i.icon.icon-check'
        z.router.link z "a.menu-item
          [href=/developers/edit-game/details/#{game?.id}]
          #{if step is 'details' then '.is-selected' else ''}
          #{if isDetailsComplete then '.is-completed' else ''}",
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Add details'
            z 'i.icon.icon-check'
        z.router.link z "a.menu-item
          [href=/developers/edit-game/upload/#{game?.id}]
          #{if step is 'upload' then '.is-selected' else ''}
          #{if isUploadComplete then '.is-completed' else ''}",
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Upload game'
            z 'i.icon.icon-check'


      z '.menu',
        z "button.menu-item.publish
          #{if not isApprovable then '[disabled]' else ''}",
          {onclick: @publish},
          z 'div.l-flex.l-vertical-center.menu-item-content',
            z 'div.text', 'Publish'
            z 'i.icon.icon-arrow-right'
