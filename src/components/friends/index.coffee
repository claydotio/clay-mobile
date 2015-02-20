z = require 'zorium'
_ = require 'lodash'
Fab = require 'zorium-paper/floating_action_button'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

PIC = 'https://secure.gravatar.com/' +
       'avatar/2f945ee6bcccd80df1834ddb3a4f18ba.jpg?s=72' # FIXME: remove

module.exports = class Friends
  constructor: ->
    styles.use()

    @state = z.state
      $fab: new Fab()
      friends: z.observe null #_.range(5)

  render: =>
    {$fab, friends} = @state()

    z '.z-friends',
      if _.isEmpty friends
        z 'div.no-friends',
          z 'i.icon.icon-group'
          z 'h2', 'Oh no! You don\'t have any friends.'
          z 'div', 'You should invite someone to join you.'
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
        z $fab, {colors: {c500: styleConfig.$orange}, $icon: '+'}
