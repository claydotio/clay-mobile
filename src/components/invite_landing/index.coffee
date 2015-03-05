z = require 'zorium'
log = require 'clay-loglevel'

PrimaryButton = require '../primary_button'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

CONTENT_HEIGHT = 128
PROMO_GAME_GRID_WIDTH = 320
PROMO_GAME_GRID_HEIGHT = 210

module.exports = class InviteLanding
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $befriendButton: new PrimaryButton()
      fromUser: z.observe User.getById fromUserId

  render: =>
    {$befriendButton, fromUser} = @state()

    z 'div.z-invite-landing',
      z 'header.header', {
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
      },
        z 'div.header-content',
          z 'h1.name', 'Clay is the best place to play!'
          z 'img.games',
            src: '//cdn.wtf/d/images/general/promo_game_grid.png'
            width: PROMO_GAME_GRID_WIDTH
            height: PROMO_GAME_GRID_HEIGHT
          z 'div.description',
            z 'div', 'Instantly play hundreds of free games.'
            z 'div', 'No downloads. No installs.'
      z 'div.content', {
        style:
          height: "#{CONTENT_HEIGHT}px"
      },
        z $befriendButton,
          text: "Become friends with #{fromUser?.name or User.DEFAULT_NAME}"
          isFullWidth: true
          onclick: ->
            User.isLoggedIn().then (isLoggedIn) ->
              if isLoggedIn
                User.addFriend(fromUser.id).then ->
                  z.router.go '/'
                .catch (err) ->
                  log.trace err
                  z.router.go '/'
              else
                z.router.go "/join?from=#{fromUser.id}"

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
