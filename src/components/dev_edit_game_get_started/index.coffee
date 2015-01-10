z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

Game = require '../../models/game'
InputBlock = require '../input_block'
InputText = require '../input_text'
InputSubdomain = require '../input_subdomain'

styles = require './index.styl'


module.exports = class DevEditGameGetStarted
  constructor: ->
    styles.use()

    @state = z.state
      gameId: null
      titleBlock: new InputBlock {
        label: 'Game Title'
        labelWidth: 125
        input: new InputText value: '', theme: '.theme-medium-width'
      }
      subdomainBlock: new InputBlock {
        label: 'Subdomain'
        labelWidth: 125
        input: new InputSubdomain value: '', theme: '.theme-small-width'
        # FIXME!
        #helpText: "Your game will be accessible at
        #           http://#{@state().gameKey}.clay.io"
      }
      gameIdBlock: new InputBlock {
        label: 'SDK Game ID'
        labelWidth: 125
        input: new InputText {
          value: ''
          disabled: true
          theme: '.theme-tiny-width'
        }
      }

  onMount: =>
    Game.getEditingGame().then (game) =>
      @state.set gameId: game.id
      @state().titleBlock.input.setValue game.name
      @state().subdomainBlock.input.setValue game.key
      @state().gameIdBlock.input.setValue game.id

  onBeforeUnmount: =>
    @save()

  save: =>
    console.log 'save'
    # images saved immediately (no need to hit 'next step')
    Game.update(@state().gameId, {
      name: @state().titleBlock.input.getValue()
      key: @state().subdomainBlock.input.getValue()
    })
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert error.detail
      throw err

  saveAndContinue: (e) =>
    e?.preventDefault()

    @save().then =>
      z.router.go "/developers/edit-game/details/#{@state().gameId}"
      .catch log.trace

  render: ({titleBlock, subdomainBlock, gameIdBlock}) ->
    isCompleted = titleBlock.input.getValue() and
                  subdomainBlock.input.getValue()

    # TODO (Austin): remove key when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-get-started', {key: 2},
      z 'form',
        {onsubmit: @saveAndContinue},

        titleBlock
        subdomainBlock
        gameIdBlock

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

        z 'a.button-primary[href=https://github.com/claydotio/clay-sdk]
          [target=blank]',
          'Add it to your game'
