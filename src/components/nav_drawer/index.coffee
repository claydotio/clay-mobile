z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

GooglePlayAdCard = require '../google_play_ad'
Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

PIC = 'https://secure.gravatar.com/' +
       'avatar/2f945ee6bcccd80df1834ddb3a4f18ba.jpg?s=72' # FIXME: remove
MENU_ITEMS = [
  {page: 'games', title: 'Games', icon: 'controller'}
  {page: 'friends', title: 'Friends', icon: 'group', reqAuth: true}
  {page: 'invite', title: 'Invite Friends', icon: 'close', reqAuth: true} # FIXME
]

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: z.observe NavDrawerModel.o_isOpen
      user: User.getMe()
      $signinButton: new Button()
      $signupButton: new Button()
      $googlePlayAdCard: new GooglePlayAdCard()
      $icons: _.reduce MENU_ITEMS, (icons, menuItem) ->
        icons[menuItem.icon] = new Icon()
        return icons
      , {}

  render: ({currentPage}) =>
    {isOpen, user, $signupButton, $signinButton,
      $googlePlayAdCard, $icons} = @state()

    isLoggedIn = user?.email # FIXME: replace with user.phoneNumber
    drawerWidth = Math.min( window.innerWidth - 56, 392 )

    z 'div.z-nav-drawer', {
      className: z.classKebab {isOpen}
    },
      z 'div.overlay', {
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.close()
      }

      z 'div.drawer', {
        style:
          width: "#{drawerWidth}px"
          left: "-#{drawerWidth}px"
      },
        z 'div.header.l-flex',
          if isLoggedIn
            z 'div.user-header.l-flex',
              z 'img.picture', src: PIC
              z 'div.name', 'Austin Hallock' # FIXME
          else
            z 'div.guest-header.l-flex',
              z 'div.description',
                z 'div', 'Unlock the full potential.'
                z 'div', 'Get social and have fun with friends.'
              z 'div.actions',
                z $signinButton,
                  text: 'Sign in'
                  colors: c500: styleConfig.$orange500, ink: styleConfig.$white
                  onclick: ->
                    # FIXME: technically this isn't necessary since NavDrawer is
                    # stored on the pagelevel and gets wiped out on route
                    NavDrawerModel.close()
                    z.router.go '/login'
                z $signupButton,
                  text: 'Sign up'
                  colors: c500: styleConfig.$white, ink: styleConfig.$orange500
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/join'
        z 'div.content',
          z 'ul.menu',
            _.map MENU_ITEMS, (menuItem) ->
              isSelected = currentPage is menuItem.page
              isUnavailable = menuItem.reqAuth and not isLoggedIn
              z "li.menu-item.menu-item-#{menuItem.page}",
                z.router.link z "a[href=/#{menuItem.page}].menu-item-link", {
                  className: z.classKebab {isSelected, isUnavailable}
                },
                  z '.icon',
                    z $icons[menuItem.icon],
                      icon: menuItem.icon
                      size: '24px'
                      color: if isSelected
                      then styleConfig.$blue500
                      else if isUnavailable
                      then styleConfig.$grey300
                      else styleConfig.$grey500
                  menuItem.title
          $googlePlayAdCard
