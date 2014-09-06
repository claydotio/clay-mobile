_ = require 'lodash'
should = require('clay-chai').should()

GameBox = require 'components/game_box'

MockGame = require '../_models/game'

describe 'GameBox', ->

  it 'sets image size', ->
    $ = new GameBox(MockGame).render()

    _.find($.children, {tag: 'img'}).attrs.width.should.be.a.Number
    _.find($.children, {tag: 'img'}).attrs.height.should.be.a.Number
