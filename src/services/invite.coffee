config = require '../config'
UrlService = require './url'

class InviteService
  getShareUrl: ({userId}) ->
    return "http://#{config.HOST}/invite-landing/#{userId}"

  sendFacebookInvite: ({userId}) =>
    inviteUrl = 'https://www.facebook.com/dialog/share?' +
    "app_id=#{config.FB_APP_ID}" +
    '&display=popup' +
    '&href=' + encodeURIComponent(@getShareUrl({userId})) +
    "&redirect_uri=http://#{config.HOST}"
    window.open inviteUrl, '_system'

  sendKikInvite: ({userId}) ->
    kik?.send? {
      title: 'Be friends with me!'
      text: 'Come be my friend and play games with me on Clay :)'
      data: {
        fromUserId: userId
      }
    }

  sendTwitterInvite: ({userId}) =>
    text = 'Come play games with me!' +
      encodeURIComponent @getShareUrl({userId})
    window.open "https://twitter.com/intent/tweet?text=#{text}", '_system'

  sendSMSInvite: ({userId}) =>
    inviteUrl = 'sms:?body=Hi! ' + encodeURIComponent @getShareUrl({userId})
    window.open inviteUrl, '_system'

module.exports = new InviteService()
