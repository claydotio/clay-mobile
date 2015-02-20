z = require 'zorium'

AppBar = require '../../components/app_bar'
Login = require '../../components/login'

styles = require './index.styl'

CONTENT_MARGIN = -56

module.exports = class JoinPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $login: new Login()

  render: =>
    {$appBar, $login} = @state()

    z 'div.z-login-page',
      z $appBar, {
        height: '224px'
        paddingBottom: CONTENT_MARGIN * -1 + 'px'
        barType: 'background'
        topLeftButton: 'back'
        topRightButton: 'signup'
        title: 'Sign in'
        description: 'Welcome back!'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "#{CONTENT_MARGIN}px"}
        $login
