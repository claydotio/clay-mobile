z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'
_ = require 'lodash'

config = require '../../config'
User = require '../../models/user'
Modal = require '../../models/modal'
ShareService = require '../../services/share'
UrlService = require '../../services/url'
PortalService = require '../../services/portal'
ModalHeader = require '../modal_header'
Icon = require '../icon'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GameShare
  constructor: ({@game}) ->
    styles.use()

    @ModalHeader = new ModalHeader {title: "#{@game.name}"}
    @onFirstRender = _.once =>
      ga? 'send', 'event', 'game_share_modal', 'open', @game.key

    @state = z.state
      $messengerIcon: new Icon()
      $shareIcon: new Icon()
      isMessengerInstalled: z.observe PortalService.call 'messenger.isInstalled'

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  shareGame: (e) =>
    e?.preventDefault()

    text = "Come play #{@game.name} with me!
           #{UrlService.getMarketplaceGame({@game})}"
    ShareService.any
      game: @game
      text: text
    .catch log.trace

    @close()

    ga? 'send', 'event', 'game_share_modal', 'share', @game.key

  render: =>
    {$shareIcon, $messengerIcon, isMessengerInstalled} = @state()

    @onFirstRender()

    z 'div.z-game-share',
      @ModalHeader
      z 'div.z-game-share-content',
        z 'div.z-game-share-message', 'Having fun? Spread the word!'
        z 'button.button-primary.z-game-share-button', {
          className: z.classKebab {isMessenger: isMessengerInstalled}
          onclick: @shareGame
        },
          if isMessengerInstalled \
          then [
            z '.icon',
              z $messengerIcon,
                icon: 'messenger-bubble'
                isTouchTarget: false
                color: styleConfig.$white
            'Send to Messenger'
          ]
          else [
            z '.icon',
              z $shareIcon,
                icon: 'share'
                isTouchTarget: false
                color: styleConfig.$white
            z '.text', 'Share with friends'
          ]
