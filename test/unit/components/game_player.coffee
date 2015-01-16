_ = require 'lodash'
should = require('clay-chai').should()
Zock = new (require 'zock')()

config = require 'config'
localstore = require 'lib/localstore'
GamePlayer = require 'components/game_player'
Modal = require 'models/modal'
MockGame = require '../../_models/game'

describe 'GamePlayer', ->
  it 'shows share modal on 3rd visit', ->
    Zock
      .base(config.CLAY_API_URL)
      .get '/games/findOne'
      .reply 200, (res) ->
        return MockGame

    gamePlayCountKey = "game:playCount:#{MockGame.key}"
    localstore.set gamePlayCountKey, {count: 0}

    GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
    GamePlayerComponent.onFirstRender()
    GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      Modal.component.should.exist
      Modal.closeComponent()
      GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
