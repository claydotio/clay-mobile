PortalService = require './portal'

tweet = (text) ->
  text = encodeURIComponent text.substr 0, 140
  PortalService.windowOpen "https://twitter.com/intent/tweet?text=#{text}"

class InviteService
  any: ({text, gameId}) ->
    PortalService.beforeWindowOpen()
    PortalService.get 'share.any',
      gameId: gameId
      text: text
    .catch (err) ->
      tweet text

module.exports = new ShareService()
