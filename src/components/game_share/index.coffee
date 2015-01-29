z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
User = require '../../models/user'
Modal = require '../../models/modal'
ShareService = require '../../services/share'
UrlService = require '../../services/url'
ModalHeader = require '../modal_header'

styles = require './index.styl'

module.exports = class GameShare
  constructor: ({@game}) ->
    styles.use()

    @ModalHeader = new ModalHeader {title: "#{@game.name}"}
    @onFirstRender = _.once =>
      ga? 'send', 'event', 'game_share_modal', 'open', @game.key

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  shareGame: (e) =>
    e?.preventDefault()

    text = "Come play #{@game.name} with me!
           #{UrlService.getMarketplaceGame({@game})}"
    ShareService.any
      gameId: @game.id
      text: text
    .catch log.trace

    @close()

    ga? 'send', 'event', 'game_share_modal', 'share', @game.key

  render: =>
    @onFirstRender()

    z 'div.z-game-share',
      @ModalHeader
      z 'div.z-game-share-content',
        z 'div.z-game-share-message', 'Having fun? Spread the word!'
        z 'button.button-primary.is-block', onclick: @shareGame,
          'Share with friends'
