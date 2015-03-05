config = require '../config'
UrlLib = require '../lib/url'
EnvironmentService = require '../services/environment'
kik = require 'kik'

class InviteService
  getUrl: ({userId}) ->
    return "http://#{config.HOST}/invite-landing/#{userId}"

  sendFacebookInvite: ({userId}) =>
    ga? 'send', 'event', 'invite', 'facebook', userId

    queryString = UrlLib.serializeQueryString {
      app_id: config.FB_APP_ID
      display: 'popup'
      href: @getUrl {userId}
      redirect_uri: "http://#{config.HOST}"
    }
    inviteUrl = "https://www.facebook.com/dialog/share?#{queryString}"

    windowTarget = if EnvironmentService.isClayApp() \
                   then '_system'
                   else '_blank'

    window.open inviteUrl, windowTarget

  sendKikInvite: ({userId}) ->
    ga? 'send', 'event', 'invite', 'kik', userId

    kik?.send? {
      title: 'Please be my friend'
      text: 'Come be my friend and play games with me on Clay :)'
      data: {
        fromUserId: userId
      }
    }

  sendTwitterInvite: ({userId}) =>
    ga? 'send', 'event', 'invite', 'twitter', userId

    queryString = UrlLib.serializeQueryString {
      text: 'Come play games with me! ' + @getUrl({userId})
    }
    inviteUrl = "https://twitter.com/intent/tweet?#{queryString}"

    windowTarget = if EnvironmentService.isClayApp() \
                   then '_system'
                   else '_blank'

    window.open inviteUrl, windowTarget

module.exports = new InviteService()
