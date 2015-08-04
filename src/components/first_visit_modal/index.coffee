z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

ModalHeader = require '../modal_header'
Game = require '../../models/game'
config = require '../../config'
GameBox = require '../game_box'
Modal = require '../../models/modal'

styles = require './index.styl'

LITTLE_ALCHEMY_GAME_ID = '42db4b0a-464e-4ae6-b06e-96440ce66573'
ZOP_GAME_ID = '7c5d01ac-9fc0-4f19-8dca-fb21e3777007'

module.exports = class FirstVisitModal
  constructor: ({gameBoxSize}) ->
    styles.use()

    # devs may not have games locally
    gameBoxes = z.observe (
      Promise.all [
        Game.get LITTLE_ALCHEMY_GAME_ID
        Game.get ZOP_GAME_ID
      ]
    ).then (games) ->
      _.map games, (game) ->
        {
          $box: new GameBox()
          game: game
        }

    @state = z.state
      $modalHeader: new ModalHeader(
        title: 'Let\'s play a game!'
      )
      gameBoxes: gameBoxes
      gameBoxSize: gameBoxSize

  onMount: ->
    ga? 'send', 'event', 'first_view_modal', 'open'

  render: =>
    {$modalHeader, gameBoxes, gameBoxSize} = @state()

    z 'div.z-first-visit-modal',
      $modalHeader
      z 'div.content',
        z 'div.message',
          z '.boxes',
            _.map gameBoxes, (gameBox) ->
              z gameBox.$box,
                game: gameBox.game
                iconSize: gameBoxSize
                onclick: ->
                  Modal.closeComponent()
