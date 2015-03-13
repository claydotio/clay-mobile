z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

ModalHeader = require '../modal_header'
EnvironmentService = require '../../services/environment'
ShareService = require '../../services/share'
Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'
UrlLib = require '../../lib/url'
UrlService = require '../../services/url'
config = require '../../config'
Game = require '../../models/game'
User = require '../../models/user'

styles = require './index.styl'

MARKETPLACE_GAME_ID = '1'

kikShare = ({text, game, me}) ->
  ga? 'send', 'event', 'game', 'share', game.key
  ga? 'send', 'event', 'share_modal', 'share', 'kik'
  kik?.send
    title: "#{game.name}"
    text: text
    data:
      gameKey: "#{game.key}"
      share:
        originUserId: me.id

twitterShare = ({text, game, me}) ->
  queryString = UrlLib.serializeQueryString {
    text: text
  }
  shareUrl = "https://twitter.com/intent/tweet?#{queryString}"

  ga? 'send', 'event', 'game', 'share', game.key
  ga? 'send', 'event', 'share_modal', 'share', 'twitter'
  UrlService.openWindow shareUrl

# TODO: (Zoli) share text, not just game
facebookShare = ({text, game, me}) ->
  href = if game.id is MARKETPLACE_GAME_ID then "http://#{config.HOST}" \
         else "http://#{config.HOST}/game/#{game.key}"

  queryString = UrlLib.serializeQueryString {
    app_id: config.FB_APP_ID
    display: 'popup'
    href: href
    redirect_uri: "http://#{config.HOST}"
  }
  shareUrl = "https://www.facebook.com/dialog/share?#{queryString}"

  ga? 'send', 'event', 'game', 'share', game.key
  ga? 'send', 'event', 'share_modal', 'share', 'facebook'
  UrlService.openWindow shareUrl

module.exports = class ShareAnyModal
  constructor: ({text, game}) ->
    styles.use()

    @state = z.state
      $modalHeader: new ModalHeader(
        title: 'Share'
      )
      text: text
      game: game
      me: User.getMe()
      shareMethods: [
        {
          className: 'kik'
          title: 'Share to Kik'
          $icon: new Icon()
          iconName: 'kik'
          shareFn: kikShare
        }
        {
          className: 'facebook'
          title: 'Share to Facebook'
          $icon: new Icon()
          iconName: 'facebook'
          shareFn: facebookShare
        }
        {
          className: 'twitter'
          title: 'Share to Twitter'
          $icon: new Icon()
          iconName: 'twitter'
          shareFn: twitterShare
        }
      ]

  onMount: ->
    ga? 'send', 'event', 'share_any_modal', 'open'

  render: =>
    {$modalHeader, shareMethods, text, game, me} = @state()

    z 'div.z-share-any-modal',
      $modalHeader
      z 'div.content',
        z 'div.message',
          _.map shareMethods, ({className, title, $icon, iconName, shareFn}) ->
            if className is 'kik' and not EnvironmentService.isKikEnabled()
              return
            z 'a[href=#].share', {
              onclick: (e) ->
                e.preventDefault()
                shareFn {text, game, me}
            },
              z "div.social-icon.#{className}",
                z 'div.icon',
                  z $icon,
                    isTouchTarget: false
                    icon: iconName
                    color: styleConfig.$white
              z 'div', title
