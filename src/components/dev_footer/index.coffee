z = require 'zorium'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class DevDashboardFooter
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-dashboard-footer',
      z '.l-content-container.l-flex',
        z 'div',
          z 'h3.title', 'About'
          z 'div.l-flex',
            z 'ul.links',
              z 'li', z.router.a '[href=/blog]', 'Blog'
              z 'li', z.router.a '[href=/team]', 'Team'
              z 'li', z.router.a '[href=/jobs]', 'Jobs'
            z 'ul.links',
              z 'li', z.router.a '[href=/contact]', 'Contact'
              z 'li', z.router.a '[href=/tos]', 'Terms'
        z 'div',
          z 'h3.title', 'Social'
          z 'ul.social',
            z 'li',
              z 'a.social-icon.facebook[href=#]'
            z 'li',
              z 'a.social-icon.twitter[href=#]'
            z 'li',
              z 'a.social-icon.google-plus[href=#]'
        z 'div.clay-info',
          z "img.cloud[src=#{styleConfig.$logoCloudSvg}]"
          z 'div.copyright', '© 2014 Clay'
