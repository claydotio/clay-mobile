PortalService = require './portal'

tweet = (text) ->
  text = encodeURIComponent text.substr 0, 140
  window.open "https://twitter.com/intent/tweet?text=#{text}"

class ShareService
  any: ({text, gameId}) ->
    PortalService.call 'share.any',
      gameId: gameId
      text: text
    .catch (err) ->
      tweet text

module.exports = new ShareService()
