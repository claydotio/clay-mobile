_ = require 'lodash'
Zock = require 'zock'
z = require 'zorium'
log = require 'clay-loglevel'

# Bind polyfill (phantomjs doesn't support bind)
# Tossing this in here is terrible practice, don't ever do it
# This is a short-term fix until we have a more elegant bind polyfill
# coffeelint: disable=missing_fat_arrows
unless Function::bind
  Function::bind = (oThis) ->

    # closest thing possible to the ECMAScript 5
    # internal IsCallable function
    throw new TypeError(
      'Function.prototype.bind - what is trying to be bound is not callable'
    ) if typeof this isnt 'function'
    aArgs = Array::slice.call(arguments, 1)
    fToBind = this
    fNOP = -> null

    fBound = ->
      fToBind.apply(
        (if this instanceof fNOP and oThis then this else oThis),
        aArgs.concat(Array::slice.call(arguments))
      )

    fNOP:: = @prototype
    fBound:: = new fNOP()
    fBound
# coffeelint: disable=missing_fat_arrows

game = (i, isNew) ->
  title = "game #{i}"

  # Prefix new games titles
  if isNew
    title = 'new ' + title

  # Every 5th game has a long title
  if i % 5 == 0
    title += ' with a really long title that is here'

  id: i
  key: i
  gameUrl: 'http://cdn.wtf/g/8/game/'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: title
  description: "This is the description for game #{i}"
  rating: i % 6

prism =
  id: 4875
  key: 'prism'
  gameUrl: 'http://192.168.2.98.xip.io:3003'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: 'Prism'
  description: 'The most amazing game ever'
  rating: 5

mock = z.prop(new Zock()
  .logger log.info
  .post '/users/login/anon'
  .reply 200, id: 1, accessToken: 'thisisanaccesstoken'
  .post '/users/me/lastEngagedActivity'
  .reply 200
  .post '/users'
  .reply 200, {params: {}, id: 1}
  .get '/games/top'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    [prism].concat(
      _.map _.range(skip, skip + limit), (i) ->
        game i
    )
  .get '/games/new'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      game i, true
  .get '/games/findOne'
  .reply 200, (res) ->
    prism
  .post '/experiments'
  .reply 200, {}
  .post '/pushTokens'
  .reply 200, (res) ->
    {gameId: prism.id, token: 'mocked_token'}
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
