z = require 'zorium'
WinkCtrl = new (require '../controllers/wink')()

module.exports = class WinkActionView
  wink: WinkCtrl.pickAndWink
  render: ->
    z 'div.wink-button', onclick: @wink, 'Wink!'
