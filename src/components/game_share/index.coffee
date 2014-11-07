z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
ModalClose = require '../modal_close'
User = require '../../models/user'
Modal = require '../../models/modal'
KikService = require '../../services/kik'

styles = require './index.styl'

module.exports = class GameShare
  constructor: ({@game, @theme}) ->
    styles.use()

    @ModalClose = new ModalClose()
    @onFirstRender = _.once =>
      ga? 'send', 'event', 'game_share_modal', 'open', @game.key

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  shareGame: (e) =>
    e?.preventDefault()
    KikService.shareGame @game
    .catch log.trace

    @close()

    ga? 'send', 'event', 'game_share_modal', 'share', @game.key

  render: =>
    @onFirstRender()

    switch @theme
      when 'bottom-dock'
      then \
        z 'div.game-share.theme-bottom-dock',
          z 'div.l-content-container',
            z 'div.game-share-header',
              z 'div.game-share-header-descriptor',
                'Noticed you were having a blast!'
              z 'h1.game-share-title', "Share #{@game.name}!"
            z 'div.game-share-buttons',
              z 'button.button-ghost.game-share-not-now',
                onclick: @close,
                'Not now'
              z 'button.button-primary', onclick: @shareGame,
                'Share with friends'

      when 'background-image'
      then \
        z 'div.game-share.theme-background-image',
          z 'div.game-share-header',
            style: "background-image: url(#{@game.promo440Url})",
            z 'div.game-share-header-text',
              z 'div.game-share-header-descriptor',
                "Looks like you're enjoying"
              z 'h1.game-share-title', "#{@game.name}"
          z 'div.game-share-content',
            z 'button.button-primary.is-block', onclick: @shareGame,
              'Share with friends'
            z 'button.button-secondary.game-share-not-now.is-block',
              onclick: @close,
              'Not now'

      when 'basic'
      then \
        z 'div.game-share.theme-basic',
          @ModalClose.render()
          z 'div.game-share-header',
            z 'h1.game-share-title', "#{@game.name}"
          z 'div.game-share-content',
            z 'div.game-share-message', 'Having fun? Spread the word!'
            z 'button.button-primary.is-block', onclick: @shareGame,
              'Share with friends'
