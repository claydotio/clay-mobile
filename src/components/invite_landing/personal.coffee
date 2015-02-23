z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

styles = require './personal.styl'

LANDCAPE_HEADER_HEIGHT = 100

module.exports = class InviteLanding
  constructor: ->
    styles.use()

    @state = z.state
      $befriendButton: new Button()
      $whatIsClayButton: new Button()

  render: =>
    {$befriendButton, $whatIsClayButton} = @state()

    headerHeight = if window.innerWidth > window.innerHeight
    then LANDCAPE_HEADER_HEIGHT
    else window.innerWidth

    z 'div.z-invite-landing-personal',
      z 'header.header.l-flex', {
        style:
          height: "#{headerHeight}px"
      },
        z 'div.header-content',
          z 'h1.name', 'Brittany' # FIXME
          z 'div.description', 'Has invited you to become friends.'
      z 'div.content.l-flex', {
        style:
          minHeight: "#{window.innerHeight - headerHeight}px"
      },
        z $befriendButton,
          text: 'Cool, I want to be friends!'
          isBlock: true
          colors: c500: styleConfig.$orange500, ink: styleConfig.$white
        z $whatIsClayButton,
          text: 'What is Clay?'
          isBlock: true
          colors: c500: styleConfig.$white, ink: styleConfig.$black26
          onclick: ->
            z.router.go '/what-is-clay'

        z.router.link z 'a[href=/join].skip-friend',
          'I prefer to play alone'
