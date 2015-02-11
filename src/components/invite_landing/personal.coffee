z = require 'zorium'
Button = require 'zorium-paper/button'

PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './personal.styl'

CONTENT_HEIGHT = 200

module.exports = class InviteLanding
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $befriendButton: new PrimaryButton()
      $whatIsClayButton: new SecondaryButton()
      fromUser: z.observe User.getById fromUserId

  render: =>
    {$befriendButton, $whatIsClayButton, fromUser} = @state()

    hasAvatar = Boolean fromUser?.avatarImage
    avatarUrl = User.getAvatarUrl(fromUser, {size: User.AVATAR_SIZES.LARGE})

    z 'div.z-invite-landing', {
      className: z.classKebab {hasAvatar}
    },
      z 'header.header', {
        style:
          height: "#{window.innerHeight - CONTENT_HEIGHT}px"
          backgroundImage: if hasAvatar
          then "url(#{avatarUrl})"
          else ''
      },
        z 'div.header-content',
          z 'h1.name', fromUser?.name
          z 'div.description',
            'Has invited you to become friends.'
      z 'div.content', {
        style:
          height: "#{CONTENT_HEIGHT}px"
      },
        z $befriendButton,
          text: 'Cool, I want to be friends!'
          isFullWidth: true
          onclick: ->
            User.isLoggedIn().then (isLoggedIn) ->
              if isLoggedIn
                User.addFriend(fromUser.id).then ->
                  z.router.go '/'
              else
                z.router.go "/join/#{fromUser.id}"

        z $whatIsClayButton,
          text: 'What is Clay?'
          isFullWidth: true
          onclick: ->
            z.router.go "/what-is-clay/#{fromUser.id}"

        z 'a[href=/join].skip-friend', {
          onclick: (e) ->
            e.preventDefault()

            User.isLoggedIn().then (isLoggedIn) ->
              z.router.go if isLoggedIn then '/' else "/join/#{fromUser.id}"
        },
          'I prefer to play alone'
