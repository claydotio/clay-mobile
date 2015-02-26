z = require 'zorium'
Button = require 'zorium-paper/button'

User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

CONTENT_HEIGHT = 128
SHORTENED_NAME_LENGTH = 15

module.exports = class InviteLanding
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()
      $whatIsClayButton: new Button()
      fromUser: z.observe User.getById fromUserId

  render: =>
    {$befriendButton, fromUser} = @state()

    shortenedName = fromUser?.name.substring(0, SHORTENED_NAME_LENGTH) or
      'everyone'

    z 'div.z-invite-landing.l-flex',
      z 'header.header', {
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
      },
        z 'div.header-content.l-flex',
          z 'h1.name', 'Clay is the best place to play!'
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
          text: "Become friends with #{shortenedName}"
          isBlock: true
          colors: c500: styleConfig.$orange500, ink: styleConfig.$white
          onclick: ->
            User.getMe().then ({phone}) ->
              isLoggedIn = Boolean phone
              if isLoggedIn
                User.addFriend(fromUser.id).then ->
                  z.router.go '/'
              else
                z.router.go "/join/#{fromUser.id}"

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
