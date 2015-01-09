z = require 'zorium'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class DevDashboardFooter
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-footer',
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
          z 'ul.social',
            z 'li',
              z 'a.social-icon.facebook' +
                '[href=https://www.facebook.com/clay.io][target=_blank]'
            z 'li',
              z 'a.social-icon.twitter' +
                '[href=https://twitter.com/claydotio][target=_blank]'
            z 'li',
              z 'a.social-icon.google-plus'+
                '[href=https://plus.google.com/+ClayIoGames][target=_blank]'
            z 'li',
              z 'a.social-icon.github' +
                '[href=https://github.com/claydotio][target=_blank]'
        z 'div.clay-info',
          z "img.cloud[src=#{styleConfig.$logoCloudSvg}]"
          z 'div.copyright', '© 2015 Clay'
