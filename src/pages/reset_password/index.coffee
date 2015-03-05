z = require 'zorium'

AppBar = require '../../components/app_bar'
BackButton = require '../../components/back_button'
ResetPassword = require '../../components/reset_password'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'
localStyleConfig = require './vars.json'

module.exports = class ResetPasswordPage
  constructor: ({}, {phone}) ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $backButton: new BackButton()
      $resetPassword: new ResetPassword()
      phone: phone

  render: =>
    {$appBar, $backButton, $resetPassword, phone} = @state()

    z 'div.z-reset-password-page',
      z $appBar, {
        height: "#{styleConfig.$appBarHeightMedium}px"
        overlapBottomPadding: "#{localStyleConfig.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: z $backButton, {isAlignedLeft: true}
        description:
          z 'div',
            z 'div', 'We\'ve texted you a reset code.'
            z 'div', 'Use it to change your password.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{localStyleConfig.$cardOverlapHeight}px"}
        z $resetPassword, {phone}
