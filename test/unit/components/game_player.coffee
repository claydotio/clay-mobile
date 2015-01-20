_ = require 'lodash'
rewire = require 'rewire'
should = require('clay-chai').should()
Zock = new (require 'zock')()
Promise = require 'bluebird'

config = require 'config'
localstore = require 'lib/localstore'
GamePlayer = rewire 'components/game_player'
Modal = require 'models/modal'
Game = require 'models/game'
MockGame = require '../../_models/game'

describe 'GamePlayer', ->
  it 'shows share modal only on 3rd visit', ->
    visitCount = 0
    overrides =
      Game:
        getByKey: (key) ->
          Promise.resolve MockGame
        incrementPlayCount: ->
          Promise.resolve visitCount

    GamePlayer.__with__(overrides) ->
      Promise.each _.range(10), (newVisitCount) ->
        visitCount += 1
        GamePlayerComponent = new GamePlayer(gameKey: MockGame.key)
        GamePlayerComponent.showShareModalPromise
        .then ->
          if visitCount is 3
            Modal.component.should.exist
            Modal.closeComponent()
          else
            should.not.exist Modal.component
