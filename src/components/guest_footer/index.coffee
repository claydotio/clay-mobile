z = require 'zorium'

config = require '../../config'
SocialIcons = require '../social_icons'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GuestFooter
  constructor: ->
    styles.use()

    @state = z.state
      $socialIcons: new SocialIcons()

  render: =>
    {$socialIcons} = @state()

    z '.z-guest-footer',
      z '.l-content-container.l-flex.content',
        z 'section.section',
          z 'h3.title', 'About'
          z 'div.l-flex.links-container',
            z 'ul.links',
              z 'li', z "a[href=//#{config.HOST}/blog]", 'Blog'
              z 'li', z "a[href=//#{config.HOST}/about]", 'Team'
              z 'li', z 'a[href=mailto:jobs@clay.io' +
                        '?Subject=Let\'s change the world]', 'Jobs'
            z 'ul.links',
              z 'li', z 'a[href=/dashboard/contact]', 'Contact'
              z 'li', z "a[href=//#{config.HOST}/tos]", 'Terms'
              z 'li', z "a[href=//#{config.HOST}/privacy]", 'Privacy'
        z '.section',
          z 'h3.title', 'Connect'
          $socialIcons
        z 'section.clay-info',
          z "img.cloud[src=#{styleConfig.$logoCloudSvg}]"
          z 'div.copyright', '© 2015 Clay'
