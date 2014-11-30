kik = require 'kik'

class EnvironmentService
  getPlatform: ->
    if kik?.enabled
      return 'kik'
    if navigator.userAgent.indexOf('Clay') isnt -1
      return 'native'

    return 'browser'

  getOS: ->
    if navigator.appVersion.indexOf('Android') isnt -1
      return 'android'
    if navigator.appVersion.indexOf('Safari') isnt -1 and
       navigator.appVersion.indexOf('Mobile') isnt -1
      return 'ios'

    return 'unknown'

module.exports = new EnvironmentService()
