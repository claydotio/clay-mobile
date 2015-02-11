z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'
AppBar = require '../app_bar'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    @state = z.state
      $appBar: new AppBar heightUnits: 4, barType: 'background'
      showProfilePicture: z.observe false # FIXME

  render: ({$appBar, showProfilePicture}) ->
    z '.z-join',
      z 'div', $appBar
      z 'h1.join-clay', 'Join Clay'
