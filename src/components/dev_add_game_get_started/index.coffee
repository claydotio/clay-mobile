z = require 'zorium'
_ = require 'lodash'

Game = require '../../models/game'
DevImageUpload = require '../dev_image_upload'
InputBlock = require '../input_block'
InputText = require '../input_text'
InputSubdomain = require '../input_subdomain'

styles = require './index.styl'


module.exports = class DevDashboardGames
  constructor: ->
    styles.use()

    @state = z.state
      gameTitle: new InputBlock {
        label: 'Game Title'
        labelWidth: 125
        input: new InputText value: '', theme: '.theme-medium-width'
      }
      gameKey: new InputBlock {
        label: 'Subdomain'
        labelWidth: 125
        input: new InputSubdomain value: '', theme: '.theme-small-width'
        # FIXME!
        #helpText: "Your game will be accessible at
        #           http://#{@state().gameKey}.clay.io"
      }
      gameId: new InputBlock {
        label: 'SDK Game ID'
        labelWidth: 125
        input: new InputText {
          value: ''
          disabled: true
          theme: '.theme-tiny-width'
        }
      }

    if Game.getEditingGame()
      Game.getEditingGame().then (game) =>
        @state().gameTitle.input.setValue game.name
        @state().gameKey.input.setValue game.key
        @state().gameId.input.setValue game.id
    else
      console.log Game.create()

  saveAndContinue: (e) ->
    console.log e
    e?.preventDefault()

    # FIXME: do correct route for edit-game
    z.router.go '/developers/add-game/details'

  render: =>
    isCompleted = @state().gameTitle.input.getValue() and
                  @state().gameKey.input.getValue()

    z 'div.z-dev-add-game-get-started',
      z 'form',
        {onsubmit: @saveAndContinue}

        @state().gameTitle
        @state().gameKey
        @state().gameId

        z 'div.l-flex',
          z 'div.l-flex-right',
            z 'button.button-secondary.next-step',
              unless isCompleted
                disabled: true
              ,
              'Next step'

      z 'hr'

      z 'div.sdk-info',
        z 'h1',
          'Enhance your game.'
          z 'br'
          'Integrate the Clay SDK now.'
        z 'ul',
          z 'li',
            z 'i.icon.icon-ads'
            'Make money with in-game ads'
          z 'li',
            z 'i.icon.icon-share'
            'Get more players with sharing'
