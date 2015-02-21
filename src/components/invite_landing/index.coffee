z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

LANDCAPE_HEADER_HEIGHT = 100

module.exports = class InviteLanding
  constructor: ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()

  render: =>
    {$befriendButton} = @state()

    headerHeight = if window.innerWidth > window.innerHeight
    then LANDCAPE_HEADER_HEIGHT
    else window.innerWidth

    z 'div.z-invite-landing',
      z 'header.header.l-flex', {
        style:
          height: "#{headerHeight}px"
      },
        z 'div.header-content',
          z 'h1.name', 'Clay is the best place to play!' # FIXME
          z 'div.description',
            z 'div', 'Instantly play hundreds of free games.'
            z 'div', 'No downloads. No installs.'
      z 'div.content.l-flex', {
        style:
          minHeight: "#{window.innerHeight - headerHeight}px"
      },
        z $befriendButton,
          text: 'Become friends with NAME' # FIXME
          isBlock: true
          colors: c500: styleConfig.$orange, ink: styleConfig.$white

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
