_ = require 'lodash'
Q = require 'q'

Game = require '../models/game'

module.exports = class GamesCtrl
  findTop: ->
    return [{url: 'http://slime.clay.io/claymedia/icon128.png'}]
