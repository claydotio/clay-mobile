z = require 'zorium'

AppBar = require '../../components/app_bar'
Join = require '../../components/join'

styles = require './index.styl'

CONTENT_MARGIN = -56

module.exports = class JoinPage
  constructor: ({fromUserId}) ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $join: new Join()
      fromUserId: fromUserId

  render: =>
    {$appBar, $join, fromUserId} = @state()

    z 'div.z-join-page',
      z $appBar, {
        height: '224px'
        paddingBottom: CONTENT_MARGIN * -1 + 'px'
        barType: 'background'
        topLeftButton: 'back'
        topRightButton: 'signin'
        title: 'Join Clay'
        description: 'Unlock the full potential.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "#{CONTENT_MARGIN}px"}
        z $join, {fromUserId}
