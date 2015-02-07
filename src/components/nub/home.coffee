z = require 'zorium'

UrlService = require '../../services/url'

styles = require './home.styl'

# if already on marketplace, keep them there with root route, otherwise
# hard redirect to marketplace
redirectToMarketplace = ->
  if UrlService.isRootPath()
    z.router.go '/'
  else
    window.location.href = UrlService.getMarketplaceBase()

module.exports = class Nub
  constructor: ->
    styles.use()

  render: ->
    z 'a[href=/].z-nub', {
      onclick: (e) ->
        e.preventDefault()
        redirectToMarketplace()
    },
      z 'i.icon.icon-home'
