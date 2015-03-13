z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

ModalHeader = require '../modal_header'
Game = require '../../models/game'
config = require '../../config'
GameBox = require '../game_box'
Modal = require '../../models/modal'

styles = require './index.styl'

LITTLE_ALCHEMY_GAME_ID = '2074'
PRISM_GAME_ID = '4875'
WORD_WARS_GAME_ID = '22'
LUNCHBUG_GAME_ID = '389'

module.exports = class FirstVisitModal
  constructor: ({gameBoxSize}) ->
    styles.use()

    # devs may not have games locally
    gameBoxes = z.observe (if config.ENV is config.ENVS.DEV
      Promise.all [
        Game.get WORD_WARS_GAME_ID
        Game.get LUNCHBUG_GAME_ID
      ]
    else
      Promise.all [
        Game.get LITTLE_ALCHEMY_GAME_ID
        Game.get PRISM_GAME_ID
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
