z = require 'zorium'

AppBar = require '../../components/app_bar'
ResetPassword = require '../../components/reset_password'

styles = require './index.styl'

CONTENT_MARGIN = -56

module.exports = class ResetPasswordPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $resetPassword: new ResetPassword()

  render: =>
    {$appBar, $resetPassword} = @state()

    z 'div.z-reset-password-page',
      z $appBar, {
        height: '224px'
        paddingBottom: CONTENT_MARGIN * -1 + 'px'
        barType: 'background'
        topLeftButton: 'back'
        title: 'Reset Password'
        description: 'Bummer. Let\'s reset it.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "#{CONTENT_MARGIN}px"}
        $resetPassword
