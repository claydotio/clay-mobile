z = require 'zorium'

config = require '../../config'
HeaderBase = require '../header_base'

module.exports = class GuestHeader
  constructor: ->
    @state = z.state
      $header: new HeaderBase()

  render: ({currentPage} = {}) =>
    {$header} = @state()
    z '.z-guest-header',
      z $header, {
        logoUrl: '//cdn.wtf/d/images/logos/logo.svg'
        homeUrl: "//#{config.HOST}/"
        links: [
          {
            text: 'Sign in'
            url: "https://#{config.DEV_HOST}/login"
            isSelected: currentPage is 'login'
          }
        ]
      }
