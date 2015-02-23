z = require 'zorium'
Card = require 'zorium-paper/card'
Button = require 'zorium-paper/button'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

PIC = 'https://secure.gravatar.com/' +
       'avatar/2f945ee6bcccd80df1834ddb3a4f18ba.jpg?s=72' # FIXME: remove

module.exports = class FriendRequestCard
  constructor: ->
    styles.use()

    @state = z.state
      $card: new Card()
      $dismissButton: new Button()
      $viewFriendsButton: new Button()
      $groupIcon: new Icon()
      dismissed: false

  render: ({newFriends}) =>
    {$card, $dismissButton, $viewFriendsButton, $groupIcon,
      dismissed} = @state()

    if dismissed
      return

    z 'div.z-friend-request-card',
      z $card,
        content:
          z 'div.z-friend-request-card_content',
            if newFriends.length is 1
              z 'div.single-friend.l-flex',
                z 'img.profile-pic', src: PIC
                z 'div.friend-info',
                  z 'div.title', 'NAME'
                  z 'div.description', 'is now your friend!'
            else
              z 'div.many-friends.l-flex',
                z 'div.profile-pic.l-flex.l-vertical-center',
                  z 'div.icon',
                    z $groupIcon, {
                      icon: 'group'
                      size: '24px'
                      color: styleConfig.$white
                    }
                z 'div.friend-info',
                  z 'div.title', "#{newFriends.length} new friends"
                  z 'div.description', 'You sure are popular!'
            z 'div.actions',
              z $dismissButton,
                text: 'Dismiss'
                colors: c500: styleConfig.$white, ink: styleConfig.$orange500
                onclick: =>
                  @state.set dismissed: true
              z $viewFriendsButton,
                text: 'View Friends'
                colors: c500: styleConfig.$white, ink: styleConfig.$orange500
                onclick: ->
                  z.router.go '/friends'
