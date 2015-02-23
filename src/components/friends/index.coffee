z = require 'zorium'
_ = require 'lodash'
Fab = require 'zorium-paper/floating_action_button'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

PIC = 'https://secure.gravatar.com/' +
       'avatar/2f945ee6bcccd80df1834ddb3a4f18ba.jpg?s=72' # FIXME: remove

module.exports = class Friends
  constructor: ->
    styles.use()

    @state = z.state
      $fab: new Fab()
      $groupIcon: new Icon()
      $addIcon: new Icon()
      friends: z.observe null #_.range(5)

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
          _.map friends, ->
            z 'li.friend',
              z 'a.friend-link.l-flex.l-vertical-center',
                z 'img.friend-pic', {src: PIC}
                z 'div.friend-info',
                  z 'div.name', 'Austin'
                  z 'div.game', 'Prism' # FIXME
                z 'img.game-pic', {src: '//cdn.wtf/g/4800/meta/icon_128.png'}

      z 'div.fab',
        z $fab,
          colors: {c500: styleConfig.$orange}
          $icon: z $addIcon,
            icon: 'close'
            size: '24px'
            color: styleConfig.$white
          onclick: ->
            z.router.go '/invite'
