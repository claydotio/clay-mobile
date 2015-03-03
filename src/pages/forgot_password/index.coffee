z = require 'zorium'

AppBar = require '../../components/app_bar'
ForgotPassword = require '../../components/forgot_password'
BackButton = require '../../components/back_button'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'
localStyleConfig = require './vars.json'

module.exports = class ForgotPasswordPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $backButton: new BackButton()
      $forgotPassword: new ForgotPassword()

  render: =>
    {$appBar, $backButton, $forgotPassword} = @state()

    z 'div.z-forgot-password-page',
      z $appBar, {
        height: "#{styleConfig.$appBarHeightTall}px"
        overlapBottomPadding: "#{localStyleConfig.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: z $backButton, {isAlignedLeft: true}
        title: 'Forgot Password'
        description: 'Bummer. Let\'s reset it.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{localStyleConfig.$cardOverlapHeight}px"}
        $forgotPassword
