z = require 'zorium'
Button = require 'zorium-paper/button'

User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

CONTENT_HEIGHT = 128

module.exports = class InviteLanding
  constructor: ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()

  render: ({fromUserId}) =>
    {$befriendButton} = @state()

    z 'div.z-invite-landing.l-flex',
      z 'header.header', {
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
      },
        z 'div.header-content.l-flex',
          z 'h1.name', 'Clay is the best place to play!' # FIXME
          z 'img.games',
            src: '//cdn.wtf/d/images/general/promo_game_grid.png'
            width: 320
            height: 210
          z 'div.description',
            z 'div', 'Instantly play hundreds of free games.'
            z 'div', 'No downloads. No installs.'
      z 'div.content.l-flex', {
        style:
          height: "#{CONTENT_HEIGHT}px"
      },
        z $befriendButton,
          text: 'Become friends with NAME' # FIXME
          isBlock: true
          colors: c500: styleConfig.$orange500, ink: styleConfig.$white
          onclick: ->
            User.getMe().then ({phone}) ->
              isLoggedIn = Boolean phone
              if isLoggedIn
                User.addFriend(fromUserId).then ->
                  z.router.go '/'
              else
                z.router.go "/join/#{fromUserId}"

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
