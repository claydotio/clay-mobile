z = require 'zorium'

DevSocialIcons = require '../dev_social_icons'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GuestFooter
  constructor: ->
    styles.use()

    @state = z.state
      DevSocialIcons: new DevSocialIcons()

  render: ({DevSocialIcons}) ->
    z '.z-guest-footer',
      z '.l-content-container.l-flex',
        z '.section',
          z 'h3.title', 'About'
          z 'div.l-flex',
            z 'ul.links',
              z 'li', z 'a[href=/blog]', 'Blog'
              z 'li', z 'a[href=/about]', 'Team'
              z 'li', z 'a[href=mailto:jobs@clay.io' +
                        '?Subject=Let\'s change the world]', 'Jobs'
            z 'ul.links',
              z 'li', z 'a[href=/contact]', 'Contact'
              z 'li', z 'a[href=/tos]', 'Terms'
              z 'li', z 'a[href=/privacy]', 'Privacy'
        z '.section',
          z 'h3.title', 'Connect'
          DevSocialIcons
        z 'div.clay-info',
          z "img.cloud[src=#{styleConfig.$logoCloudSvg}]"
          z 'div.copyright', '© 2015 Clay'
