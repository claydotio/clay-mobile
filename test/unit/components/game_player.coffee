_ = require 'lodash'
should = require('clay-chai').should()

GamePlayer = require 'components/game_player'
Modal = require 'models/modal'

MockGame = require '../../_models/game'

describe 'GamePlayer', ->
  it 'shows share modal on 3rd visit', ->
    GamePlayerComponent = new GamePlayer(MockGame)
    GamePlayerComponent.onFirstRender()
    GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(MockGame)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(MockGame)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      Modal.component.should.exist
      Modal.closeComponent()
      GamePlayerComponent = new GamePlayer(MockGame)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
    .then ->
      should.not.exist(Modal.component)
      GamePlayerComponent = new GamePlayer(MockGame)
      GamePlayerComponent.onFirstRender()
      GamePlayerComponent.showShareModalPromise
