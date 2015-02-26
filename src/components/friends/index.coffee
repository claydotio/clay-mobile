z = require 'zorium'
_ = require 'lodash'
Fab = require 'zorium-paper/floating_action_button'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'
ImageService = require '../../services/image'

styles = require './index.styl'

module.exports = class Friends
  constructor: ->
    styles.use()

    @state = z.state
      $fab: new Fab()
      $groupIcon: new Icon()
      $addIcon: new Icon()
      friends: z.observe User.getFriends()

  render: =>
    {$fab, $groupIcon, $addIcon, friends} = @state()

    z '.z-friends',
      if _.isEmpty friends
        z 'div.no-friends',
          z $groupIcon,
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
              z 'a.friend-link.l-flex.l-vertical-center',
                z 'img.friend-avatar',
                  src: ImageService.getAvatarUrl friend
                z 'div.friend-info',
                  z 'div.name', 'Austin'
                  if mostRecentGame
                    z 'div.game', mostRecentGame.name
                if mostRecentGame
                  z 'img.game-pic',
                    src: ImageService.getGameIconUrl mostRecentGame

      z 'div.fab',
        z $fab,
          colors: {c500: styleConfig.$orange500}
          $icon: z $addIcon,
            icon: 'add'
            size: '24px'
            color: styleConfig.$white
          onclick: ->
            z.router.go '/invite'
