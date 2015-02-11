z = require 'zorium'

styles = require './index.styl'

module.exports = class FeedbackCard
  constructor: ->
    styles.use()

  render: ->
    z 'a.z-feedback-card[href=#]',
      onclick: (e) ->
        e.preventDefault()
        kik?.openConversation 'clayfeedback'
      z 'div.header'
      z 'div.content',
        z 'h2', 'Hey you!'
        z 'div.message',
          z 'div', 'We think you\'re awesome and want your'
          z 'div', 'feedback on how we can make this better!'
      z 'button.button-ghost.is-block.message-button',
        z 'i.icon.icon-chat'
        z 'span.button-text', 'Message us'
