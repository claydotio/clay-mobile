_ = require 'lodash'
should = require('clay-chai').should()

GameBox = require 'components/game_box'

MockGame = require '../../_models/game'

describe 'GameBox', ->

  it 'sets image size', ->
    $box = new GameBox()
    $ = $box.render({game: MockGame, iconSize: 100})

    _.find($.children, {tagName: 'IMG'}).properties.width.should.be 100
    _.find($.children, {tagName: 'IMG'}).properties.height.should.be 100
