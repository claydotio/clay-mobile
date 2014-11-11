_ = require 'lodash'
should = require('clay-chai').should()

GamePromo = require 'components/game_promo'

MockGame = require '../../_models/game'

describe 'GamePromo', ->

  it 'sets image size', ->
    $ = new GamePromo({game: MockGame, width: 100, height: 50}).render()

    _.find($.children, {tag: 'img'}).attrs.width.should.be 100
    _.find($.children, {tag: 'img'}).attrs.height.should.be 50