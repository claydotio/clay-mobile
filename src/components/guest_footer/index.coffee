z = require 'zorium'

SocialIcons = require '../social_icons'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GuestFooter
  constructor: ->
    styles.use()

    @state = z.state
      SocialIcons: new SocialIcons()

  render: ({SocialIcons}) ->
    z '.z-guest-footer',
      z '.l-content-container.l-flex.content',
        z 'section.section',
          z 'h3.title', 'About'
          z 'div.l-flex.links-container',
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
          SocialIcons
        z 'section.clay-info',
          z "img.cloud[src=#{styleConfig.$logoCloudSvg}]"
          z 'div.copyright', '© 2015 Clay'
