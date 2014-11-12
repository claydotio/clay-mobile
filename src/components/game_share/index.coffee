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

    z 'div.game-share',
      @ModalClose.render()
      z 'div.game-share-header',
        z 'h1.game-share-title', "#{@game.name}"
      z 'div.game-share-content',
        z 'div.game-share-message', 'Having fun? Spread the word!'
        z 'button.button-primary.is-block', onclick: @shareGame,
          'Share with friends'
