Zock = require 'zock'
z = require 'zorium'

mock = z.prop(new Zock()
  .logger (x) -> console.log x
  .get '/users/params'
  .reply 200, [
    {id: 'login_button'}
    {id: 'signup_button'}
    {id: 'message_button'}
    {id: 'play_button_color'}
    {id: 'share_button_size'}
  ]
  .get '/conversions'
  .reply 200, [
    {id: 'game_play'}
    {id: 'game_share'}
    {id: 'signup'}
    {id: 'message_friend'}
  ]
  .get '/conversions/:event'
  .reply 200, {
    views: [
      { param: 'green', count: 1000 }
      { param: 'red', count: 1100 }
      { param: 'blue', count: 900 }
      { param: 'pink', count: 1010 }
    ]
    counts: [
      [
        { date: new Date(), value: 'green', count: 32 }
        { date: new Date(), value: 'red', count: 2 }
        { date: new Date(), value: 'blue', count: 12 }
        { date: new Date(), value: 'pink', count: 102 }
      ]
      [
        { date: new Date(), value: 'green', count: 2 }
        { date: new Date(), value: 'blue', count: 8 }
        { date: new Date(), value: 'pink', count: 70 }
      ]
      [
        { date: new Date(), value: 'green', count: 62 }
        { date: new Date(), value: 'red', count: 24 }
        { date: new Date(), value: 'blue', count: 32 }
        { date: new Date(), value: 'pink', count: 202 }
      ]
      [
        { date: new Date(), value: 'green', count: 412 }
        { date: new Date(), value: 'red', count: 24 }
        { date: new Date(), value: 'blue', count: 120 }
        { date: new Date(), value: 'pink', count: 152 }
      ]
    ]
  }
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
