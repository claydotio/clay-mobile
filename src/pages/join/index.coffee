z = require 'zorium'

AppBar = require '../../components/app_bar'
BackButton = require '../../components/back_button'
Join = require '../../components/join'
stylusConfig = require '../../stylus/vars.json'

styles = require './index.styl'
localStyleConfig = require './vars.json'

module.exports = class JoinPage
  constructor: ({}, {from}) ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $backButton: new BackButton()
      $join: new Join()
      fromUserId: from

  render: =>
    {$appBar, $backButton, $join, fromUserId} = @state()

    loginRoute = if fromUserId \
                 then "/login?from=#{fromUserId}"
                 else '/login'

    z 'div.z-join-page',
      z $appBar, {
        height: "#{stylusConfig.$appBarHeightTall}px"
        overlapBottomPadding: "#{localStyleConfig.$cardOverlapHeight}px"
        isDescriptive: true
        $topLeftButton: z $backButton, {isAlignedLeft: true}
        $topRightButton: z.router.link z "a[href=#{loginRoute}].sign-in",
                          'Sign In'
        title: 'Join Clay'
        description: 'Unlock the full potential.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "-#{localStyleConfig.$cardOverlapHeight}px"}
        z $join, {fromUserId}
