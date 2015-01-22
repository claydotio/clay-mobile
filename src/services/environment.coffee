kik = require 'kik'

class EnvironmentService
  isMobile: ->
    ///
      Mobile
    | iP(hone|od|ad)
    | Android
    | BlackBerry
    | IEMobile
    | Kindle
    | NetFront
    | Silk-Accelerated
    | (hpw|web)OS
    | Fennec
    | Minimo
    | Opera\ M(obi|ini)
    | Blazer
    | Dolfin
    | Dolphin
    | Skyfire
    | Zune
    ///.test navigator.userAgent

  isAndroid: ->
    _.contains navigator.appVersion, 'Android'

  isClayApp: ->
    _.contains navigator.userAgent, 'Clay'

  # Kik.enabled is not documented by Kik - could change version-by-version
  isKikEnabled: ->
    kik?.enabled

module.exports = new EnvironmentService()
