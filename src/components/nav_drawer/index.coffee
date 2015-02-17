z = require 'zorium'
log = require 'clay-loglevel'

config = require '../../config'
NavDrawerModel = require '../../models/nav_drawer'

styles = require './index.styl'

module.exports = class NavDrawer
  constructor: ->
    styles.use()

    @state = z.state
      isOpen: z.observe NavDrawerModel.o_isOpen

  render: =>
    {isOpen} = @state()

    z 'div.z-nav-drawer', {
      className: z.classKebab {isOpen}
    },
      z 'div.overlay', {
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.close()
      }

      z 'div.drawer',
        z 'div.header.l-flex',
          z 'div.name', 'Austin Hallock' # FIXME
        z 'div.content',
          z 'ul.menu',
            z 'li.menu-item',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-menu' # FIXME
                'Games'
            z 'li.menu-item',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-back-arrow' # FIXME
                'Friends'
            z 'li.menu-item',
              z 'a[href=#].menu-item-link',
                z 'i.icon.icon-heart' # FIXME
                'Invite Friends'
