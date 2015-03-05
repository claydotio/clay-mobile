z = require 'zorium'
_ = require 'lodash'
Promise = require 'bluebird'
Fab = require 'zorium-paper/floating_action_button'

Icon = require '../icon'
Spinner = require '../spinner'
styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'
Game = require '../../models/game'
request = require '../../lib/request'
UrlService = require '../../services/url'

styles = require './index.styl'

module.exports = class Friends
  constructor: ->
    styles.use()

    @state = z.state
      $addFriendFab: new Fab()
      $groupIcon: new Icon()
      $addIcon: new Icon()
      $spinner: new Spinner()
      friends: z.observe User.getFriends().then (friends) ->
        Promise.map friends, (friend) ->
          recentGamesHref = friend.links.recentGames?.href
          if recentGamesHref
            request friend.links.recentGames.href
            .then (recentGames) ->
              friend.mostRecentGame = recentGames[0]
              return friend
          else
            return friend

  render: =>
    {$addFriendFab, $groupIcon, $addIcon, $spinner, friends} = @state()

    z '.z-friends',
      if friends is null
        z 'div.spinner', $spinner
      else if _.isEmpty friends
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
            z 'li.friend',
              z.router.link z 'a.friend-link',
                if friend.mostRecentGame then {
                  href: UrlService.getGameRoute {game: friend.mostRecentGame}
                }
                else {
                  href: '#'
                },
                z 'img.friend-avatar',
                  src: User.getAvatarUrl friend
                z 'div.friend-info',
                  z 'div.name', friend.name or User.DEFAULT_NAME
                  if friend.mostRecentGame
                    z 'div.game', friend.mostRecentGame.name
                if friend.mostRecentGame
                  z 'img.game-pic',
                    src: Game.getIconUrl friend.mostRecentGame

      z 'div.fab',
        z $addFriendFab,
          colors: {c500: styleConfig.$orange500}
          $icon: z $addIcon,
            isTouchTarget: false
            icon: 'add'
            color: styleConfig.$white
          onclick: ->
            z.router.go '/invite'
