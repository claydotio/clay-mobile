z = require 'zorium'

AppBar = require '../../components/app_bar'
Join = require '../../components/join'

styles = require './index.styl'

CONTENT_MARGIN = -56

module.exports = class JoinPage
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar()
      $join: new Join()

  render: =>
    {$appBar, $join} = @state()

    z 'div.z-join-page',
      z $appBar, {
        height: '224px'
        paddingBottom: CONTENT_MARGIN * -1 + 'px'
        barType: 'background'
        navButton: 'back'
        title: 'Join Clay'
        description: 'Unlock the full potential.'
      }
      z 'div.l-content-container.content',
        {style: marginTop: "#{CONTENT_MARGIN}px"}
        $join
