z = require 'zorium'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class DevSocialIcons
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-social-icons',
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
