z = require 'zorium'
Button = require 'zorium-paper/button'

Icon = require '../icon'
Card = require '../card'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class FriendRequestCard
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      $viewFriendsButton: new Button()
      $groupIcon: new Icon()
      isDismissed: false

  render: ({friends}) =>
    {$card, $dismissButton, $viewFriendsButton, $groupIcon,
      isDismissed} = @state()

    # TODO: (Austin) re-implement as stream
    if isDismissed
      return

    z 'div.z-friend-request-card',
      z $card,
        content:
          z 'div.z-friend-request-card_content',
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
                      icon: 'group'
                      size: '24px'
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
