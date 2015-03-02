z = require 'zorium'

AppBar = require '../../components/app_bar'
BackButton = require '../../components/back_button'
Login = require '../../components/login'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'
localStyleConfig = require './vars.json'

module.exports = class LoginPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $backButton: new BackButton()
      $login: new Login()

  render: =>
    {$appBar, $backButton, $login} = @state()

    z 'div.z-login-page',
      z $appBar, {
        height: "#{styleConfig.$appBarHeightTall}px"
        overlapBottomPadding: "#{localStyleConfig.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: z $backButton, {isShiftedLeft: true}
        $topRightButton: z.router.link z 'a[href=/join].sign-in', 'Sign Up'
        title: 'Sign in'
        description: 'Welcome back!'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{localStyleConfig.$cardOverlapHeight}px"}
        $login
