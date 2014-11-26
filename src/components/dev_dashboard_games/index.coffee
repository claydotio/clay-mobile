z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class DevDashboardGames
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-dev-dashboard-games',
      z '.title', 'My games'
      z 'div.container',
        _.map _.range(3), ->
          z 'div.game-container',
            z 'div.game',
              z '.image-content',
                z '.image-background'
                z '.image-overlay',
                  z 'img[src=//lorempixel.com/100/100/abstract]'
                  z '.image-text', 'Prism'
              z '.actions',
                z 'span.status', 'Published'
                z 'span.edit',
                  z 'i.icon.icon-edit'
                  z 'span', 'Edit'
                z 'span.delete',
                  z 'i.icon.icon-edit'
                  z 'span', 'Delete'
