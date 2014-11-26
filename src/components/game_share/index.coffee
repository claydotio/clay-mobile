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
  constructor: ({@game}) ->
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

    z 'div.z-game-share',
      @ModalClose
      z 'div.z-game-share-header',
        z 'h1.z-game-share-title', "#{@game.name}"
      z 'div.z-game-share-content',
        z 'div.z-game-share-message', 'Having fun? Spread the word!'
        z 'button.button-primary.is-block', onclick: @shareGame,
          'Share with friends'
