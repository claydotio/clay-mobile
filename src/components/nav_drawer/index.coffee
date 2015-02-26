z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

GooglePlayAdCard = require '../google_play_ad'
Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
User = require '../../models/user'
ImageService = require '../../services/image'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

MENU_ITEMS = [
  {page: 'games', title: 'Games', icon: 'controller'}
  {page: 'friends', title: 'Friends', icon: 'group', reqAuth: true}
  {page: 'invite', title: 'Invite Friends', icon: 'addCircle', reqAuth: true}
]

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: z.observe NavDrawerModel.o_isOpen
      me: User.getMe()
      $signinButton: new Button()
      $signupButton: new Button()
      $googlePlayAdCard: new GooglePlayAdCard()
      $icons: _.reduce MENU_ITEMS, (icons, menuItem) ->
        icons[menuItem.icon] = new Icon()
        return icons
      , {}

  render: ({currentPage}) =>
    {isOpen, me, $signupButton, $signinButton,
      $googlePlayAdCard, $icons} = @state()

    # FIXME: check that me as observable gets updated when profile pic is uploaded

    isLoggedIn = me?.phone
    drawerWidth = Math.min( window.innerWidth - 56, 392 )

    z 'div.z-nav-drawer', {
      className: z.classKebab {isOpen}
    },
      z 'div.overlay', {
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.close()
      }

      z 'div.drawer.l-flex', {
        style:
          width: "#{drawerWidth}px"
          transform: "translate(-#{drawerWidth}px, 0)"
          webkitTransform: "translate(-#{drawerWidth}px, 0)"
      },
        z 'div.header.l-flex',
          if isLoggedIn
            z 'div.user-header.l-flex',
              z 'img.avatar', src: ImageService.getAvatarUrl me
              z 'div.name', me.name
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
        z 'div.content.l-flex-1',
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
