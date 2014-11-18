_ = require 'lodash'
should = require('clay-chai').should()

GamePlayer = require 'components/game_player'
Modal = require 'models/modal'
localstore = require 'lib/localstore'

MockGame = require '../../_models/game'

describe 'GamePlayer', ->
  it 'shows share modal on 3rd visit', ->
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
