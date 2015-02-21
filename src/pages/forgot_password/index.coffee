z = require 'zorium'

AppBar = require '../../components/app_bar'
ForgotPassword = require '../../components/forgot_password'

styles = require './index.styl'

CONTENT_MARGIN = -56

module.exports = class ForgotPasswordPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $forgotPassword: new ForgotPassword()

  render: =>
    {$appBar, $forgotPassword} = @state()

    z 'div.z-forgot-password-page',
      z $appBar, {
        height: '224px'
        paddingBottom: CONTENT_MARGIN * -1 + 'px'
        barType: 'background'
        topLeftButton: 'back'
        title: 'Forgot Password'
        description: 'Bummer. Let\'s reset it.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "#{CONTENT_MARGIN}px"}
        $forgotPassword
