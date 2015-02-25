z = require 'zorium'
Button = require 'zorium-paper/button'

User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './personal.styl'

CONTENT_HEIGHT = 200

module.exports = class InviteLanding
  constructor: ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()
      $whatIsClayButton: new Button()

  render: ({fromUserId}) =>
    {$befriendButton, $whatIsClayButton} = @state()

    z 'div.z-invite-landing.l-flex',
      z 'header.header.l-flex', {
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
      },
        z 'div.header-content',
          z 'h1.name', 'Brittany'
          z 'div.description',
            'Has invited you to become friends.'
      z 'div.content.l-flex', {
        style:
          height: "#{CONTENT_HEIGHT}px"
      },
        z $befriendButton,
          text: 'Cool, I want to be friends!'
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

        z $whatIsClayButton,
          text: 'What is Clay?'
          isBlock: true
          colors: c500: styleConfig.$white, ink: styleConfig.$black26
          onclick: ->
            z.router.go '/what-is-clay'

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
