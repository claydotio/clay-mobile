z = require 'zorium'
Button = require 'zorium-paper/button'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class FriendRequestCard
  constructor: ->
    styles.use()

    @state = z.state
      $dismissButton: new Button()
      $viewFriendsButton: new Button()
      $groupIcon: new Icon()
      isDismissed: false

  render: ({friends}) =>
    {$dismissButton, $viewFriendsButton, $groupIcon,
      isDismissed} = @state()

    # TODO: (Austin) re-implement as stream where parent handles show/hide
    if isDismissed
      return

    z 'div.z-friend-request-card',
      if friends.length is 1
        z 'div.single-friend',
          z 'img.profile-pic',
            src: User.getAvatarUrl friends[0]
          z 'div.friend-info',
            z 'div.title', friends[0].name
            z 'div.description', 'is now your friend!'
      else
        z 'div.many-friends',
          z 'div.profile-pic',
            z 'div.icon',
              z $groupIcon, {
                isTouchTarget: false
                icon: 'group'
                color: styleConfig.$white
              }
          z 'div.friend-info',
            z 'div.title', "#{friends.length} new friends"
            z 'div.description', 'You sure are popular!'
      z 'div.actions',
        z $dismissButton,
          text: 'Dismiss'
          colors:
            c500: styleConfig.$white
            ink: styleConfig.$orange500
          onclick: =>
            @state.set isDismissed: true
        z $viewFriendsButton,
          text: 'View Friends'
          colors:
            c500: styleConfig.$white
            ink: styleConfig.$orange500
          onclick: ->
            z.router.go '/friends'
