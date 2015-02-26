z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

GooglePlayAdCard = require '../google_play_ad'
Icon = require '../icon'
ButtonPrimary = require '../button_primary'
NavDrawerModel = require '../../models/nav_drawer'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

DRAWER_RIGHT_PADDING = 56
DRAWER_MAX_WIDTH = 392

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: NavDrawerModel.isOpen()
      me: User.getMe()
      isLoggedIn: User.isLoggedIn()
      $signinButton: new ButtonPrimary()
      $signupButton: new Button()
      $googlePlayAdCard: new GooglePlayAdCard()
      $icons: _.reduce NavDrawer.PAGES, (icons, page) ->
        icons[page.ICON] = new Icon()
        return icons
      , {}

  render: ({currentPage}) =>
    {isOpen, me, isLoggedIn, $signupButton, $signinButton,
      $googlePlayAdCard, $icons} = @state()

    drawerWidth = Math.min \
      window.innerWidth - DRAWER_RIGHT_PADDING, DRAWER_MAX_WIDTH

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
          transform: "translate(-#{drawerWidth}px, 0)"
          webkitTransform: "translate(-#{drawerWidth}px, 0)"
      },
        z 'div.header',
          if isLoggedIn
            z 'div.user-header',
              z 'img.avatar', src: User.getAvatarUrl me
              z 'div.name', me.name
          else
            z 'div.guest-header',
              z 'div.description',
                z 'div', 'Unlock the full potential.'
                z 'div', 'Get social and have fun with friends.'
              z 'div.actions',
                z $signinButton,
                  text: 'Sign in'
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/login'
                z $signupButton,
                  text: 'Sign up'
                  colors:
                    c500: styleConfig.$white
                    ink: styleConfig.$orange500
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/join'
        z 'div.content',
          z 'ul.menu',
            _.map NavDrawer.PAGES, (page) ->
              isSelected = currentPage is page.ROUTE
              isUnavailable = page.REQ_AUTH and not isLoggedIn
              z "li.menu-item.menu-item-#{page.ROUTE}", {
                className: z.classKebab {isSelected, isUnavailable}
              },
                z "a[href=/#{page.ROUTE}].menu-item-link", {
                  onclick: (e) ->
                    e.preventDefault()
                    NavDrawerModel.close()
                    z.router.go "/#{page.ROUTE}"
                },
                  z '.icon',
                    z $icons[page.ICON],
                      icon: page.ICON
                      size: '24px'
                      color: if isSelected
                      then styleConfig.$blue500
                      else if isUnavailable
                      then styleConfig.$grey300
                      else styleConfig.$grey500
                  page.TITLE
          $googlePlayAdCard

NavDrawer.PAGES =
  GAMES:
    ROUTE: 'games'
    TITLE: 'Games'
    ICON: 'controller'
  FRIENDS:
    ROUTE: 'friends'
    TITLE: 'Friends'
    ICON: 'group'
    REQ_AUTH: true
  INVITE:
    ROUTE: 'invite'
    TITLE: 'Invite Friends'
    ICON: 'addCircle'
    REQ_AUTH: true
