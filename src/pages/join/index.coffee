z = require 'zorium'

AppBar = require '../../components/app_bar'
BackButton = require '../../components/back_button'
Join = require '../../components/join'
stylusConfig = require '../../stylus/vars.json'

styles = require './index.styl'
vars = require './vars.json'

module.exports = class JoinPage
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $backButton: new BackButton()
      $join: new Join()
      fromUserId: fromUserId

  render: =>
    {$appBar, $backButton, $join, fromUserId} = @state()

    z 'div.z-join-page',
      z $appBar, {
        height: "#{stylusConfig.$appBarHeightTall}px"
        overlapBottomPadding: "#{vars.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: $backButton
        $topRightButton: z.router.link z 'a[href=/login].sign-in', 'Sign In'
        title: 'Join Clay'
        description: 'Unlock the full potential.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{vars.$cardOverlapHeight}px"}
        z $join, {fromUserId}
