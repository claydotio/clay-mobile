z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

config = require '../../config'
NavDrawerModel = require '../../models/nav_drawer'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: z.observe NavDrawerModel.o_isOpen
      user: User.getMe()
      $signinButton: new Button()
      $signupButton: new Button()

  render: =>
    {isOpen, user, $signupButton, $signinButton} = @state()

    isLoggedIn = user?.email # FIXME: replace with user.phoneNumber

    z 'div.z-nav-drawer', {
      className: z.classKebab {isOpen}
    },
      z 'div.overlay', {
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.close()
      }

      z 'div.drawer',
        z 'div.header.l-flex',
          if isLoggedIn
            z 'div.name', 'Austin Hallock' # FIXME
          else
            z 'div.guest-header.l-flex',
              z 'div.description',
                z 'div', 'Unlock the full potential.'
                z 'div', 'Get social and have fun with friends.'
              z 'div.actions',
                z $signinButton,
                  text: 'Sign in'
                  colors: c500: styleConfig.$orange, ink: styleConfig.$white
                  onclick: ->
                    # FIXME: technically this isn't necessary since NavDrawer is stored on the pagelevel and gets wiped out on route
                    NavDrawerModel.close()
                    z.router.go '/login'
                z $signupButton,
                  text: 'Sign up'
                  colors: c500: styleConfig.$white, ink: styleConfig.$orange
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/join'
        z 'div.content',

          z 'ul.menu', {className: z.classKebab {isLoggedIn}},
            z 'li.menu-item.menu-item-games',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-menu' # FIXME
                'Games'
            z 'li.menu-item.menu-item-friends',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-back-arrow' # FIXME
                'Friends'
            z 'li.menu-item.menu-item-invite',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-heart' # FIXME
                'Invite Friends'
