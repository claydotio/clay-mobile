z = require 'zorium'
log = require 'clay-loglevel'
Button = require 'zorium-paper/button'

GooglePlayAdCard = require '../google_play_ad'
Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
User = require '../../models/user'
GooglePlayAdService = require '../../services/google_play_ad'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

DRAWER_RIGHT_PADDING = 56
DRAWER_MAX_WIDTH = 336

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: NavDrawerModel.isOpen()
      me: User.getMe()
      isLoggedIn: User.isLoggedIn()
      $signinButton: new Button()
      $signupButton: new Button()
      $googlePlayAdCard: if GooglePlayAdService.shouldShowAds() \
                         then new GooglePlayAdCard()
                         else null
      pages: [
        {
          page: NavDrawer.PAGES.GAMES
          title: 'Games'
          $icon: new Icon()
          iconName: 'controller'
        }
        {
          page: NavDrawer.PAGES.FRIENDS
          title: 'Friends'
          $icon: new Icon()
          iconName: 'group'
          reqAuth: true
        }
        {
          page: NavDrawer.PAGES.INVITE
          title: 'Invite Friends'
          $icon: new Icon()
          iconName: 'add-circle'
          reqAuth: true
        }
      ]


  render: ({currentPage}) =>
    {isOpen, me, isLoggedIn, $signupButton, $signinButton,
      $googlePlayAdCard, pages} = @state()

    drawerWidth = Math.min \
      window.innerWidth - DRAWER_RIGHT_PADDING, DRAWER_MAX_WIDTH
    translateX = if isOpen then '0' else "-#{drawerWidth}px"

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
          transform: "translate(#{translateX}, 0)"
          webkitTransform: "translate(#{translateX}, 0)"
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
                  colors:
                    ink: styleConfig.$white
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/login'
                z $signupButton,
                  text: 'Sign up'
                  isRaised: true
                  colors:
                    c500: styleConfig.$white
                    c600: styleConfig.$white
                    c700: styleConfig.$white
                    ink: styleConfig.$orange500
                  onclick: ->
                    NavDrawerModel.close()
                    z.router.go '/join'
        z 'div.content',
          z 'ul.menu',
            _.map pages, ({page, title, $icon, iconName, reqAuth}) ->
              isSelected = currentPage is page
              isUnavailable = reqAuth and not isLoggedIn
              z "li.menu-item.menu-item-#{page}", {
                className: z.classKebab {isSelected, isUnavailable}
              },
                z "a[href=/#{page}].menu-item-link", {
                  onclick: (e) ->
                    e.preventDefault()
                    NavDrawerModel.close()
                    z.router.go "/#{page}"
                },
                  z '.icon',
                    z $icon,
                      isTouchTarget: false
                      icon: iconName
                      color: if isSelected
                      then styleConfig.$blue500
                      else if isUnavailable
                      then styleConfig.$grey300
                      else styleConfig.$grey500
                  title
          $googlePlayAdCard

NavDrawer.PAGES =
  GAMES: 'games'
  FRIENDS: 'friends'
  INVITE: 'invite'
