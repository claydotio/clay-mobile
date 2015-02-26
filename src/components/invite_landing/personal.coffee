z = require 'zorium'
Button = require 'zorium-paper/button'

User = require '../../models/user'
ImageService = require '../../services/image'
styleConfig = require '../../stylus/vars.json'

styles = require './personal.styl'

CONTENT_HEIGHT = 200

module.exports = class InviteLanding
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()
      $whatIsClayButton: new Button()
      fromUser: z.observe User.getById fromUserId

  render: =>
    {$befriendButton, $whatIsClayButton, fromUser} = @state()

    hasAvatar = Boolean fromUser?.avatarImage

    z 'div.z-invite-landing.l-flex',
      z 'header.header.l-flex', {
        className: z.classKebab {hasAvatar}
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
          backgroundImage: if hasAvatar
          then "url(#{ImageService.getAvatarUrl(fromUser, {size: 'large'})})"
          else ''
      },
        z 'div.header-content',
          z 'h1.name', fromUser?.name
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
                User.addFriend(fromUser.id).then ->
                  z.router.go '/'
              else
                z.router.go "/join/#{fromUser.id}"

        z $whatIsClayButton,
          text: 'What is Clay?'
          isBlock: true
          colors: c500: styleConfig.$white, ink: styleConfig.$black26
          onclick: ->
            z.router.go "/what-is-clay/#{fromUser.id}"

        z 'a[href=/join].skip-friend', {
          onclick: (e) ->
            e.preventDefault()

            User.getMe().then ({phone}) ->
              isLoggedIn = Boolean phone
              z.router.go if isLoggedIn then '/' else "/join/#{fromUser.id}"
        },
          'I prefer to play alone'
