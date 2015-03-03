z = require 'zorium'
_ = require 'lodash'
Fab = require 'zorium-paper/floating_action_button'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'
Game = require '../../models/game'

styles = require './index.styl'

module.exports = class Friends
  constructor: ->
    styles.use()

    @state = z.state
      $addFriendFab: new Fab()
      $groupIcon: new Icon()
      $addIcon: new Icon()
      friends: z.observe User.getFriends()

  render: =>
    {$addFriendFab, $groupIcon, $addIcon, friends} = @state()

    z '.z-friends',
      if _.isEmpty friends
        z 'div.no-friends',
          z $groupIcon,
            isTouchTarget: false
            icon: 'group'
            size: '80px'
            color: styleConfig.$grey300
          z 'h2.title', 'Oh no! You don\'t have any friends.'
          z 'div.description', 'You should invite someone to join you.'
      else
        z 'ul.friends',
          _.map friends, (friend) ->
            mostRecentGame = friend.links.recentGames?[0]
            z 'li.friend',
              z 'a.friend-link',
                z 'img.friend-avatar',
                  src: User.getAvatarUrl friend
                z 'div.friend-info',
                  z 'div.name', friend.name
                  if mostRecentGame
                    z 'div.game', mostRecentGame.name
                if mostRecentGame
                  z 'img.game-pic',
                    src: Game.getIconUrl mostRecentGame

      z 'div.fab',
        z $addFriendFab,
          colors: {c500: styleConfig.$orange500}
          $icon: z $addIcon,
            isTouchTarget: false
            icon: 'add'
            color: styleConfig.$white
          onclick: ->
            z.router.go '/invite'
