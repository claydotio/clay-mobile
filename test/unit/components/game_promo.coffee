_ = require 'lodash'
should = require('clay-chai').should()

GamePromo = require 'components/game_promo'

MockGame = require '../../_models/game'

describe 'GamePromo', ->

  it 'sets image size', ->
    $ = new GamePromo().render({game: MockGame, width: 100, height: 50})

    _.find($.children, {tagName: 'IMG'}).properties.width.should.be 100
    _.find($.children, {tagName: 'IMG'}).properties.height.should.be 50
