z = require 'zorium'

AppBar = require '../../components/app_bar'
BackButton = require '../../components/back_button'
Login = require '../../components/login'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'
vars = require './vars.json'

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
        overlapBottomPadding: "#{vars.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: $backButton
        $topRightButton: z.router.link z 'a[href=/join].sign-in', 'Sign Up'
        title: 'Sign in'
        description: 'Welcome back!'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{vars.$cardOverlapHeight}px"}
        $login
