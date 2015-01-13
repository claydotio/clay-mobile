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
      game: null
      titleBlock: new InputBlock {
        label: 'Game Title'
        labelWidth: 125
        input: new InputText {
          value: ''
          theme: '.theme-medium-width'
          onchange: (val) ->
            Game.updateEditingGame name: val
            .catch log.trace
        }
      }
      subdomainBlock: new InputBlock {
        label: 'Subdomain'
        labelWidth: 125
        input: new InputSubdomain {
          value: ''
          theme: '.theme-small-width'
          onchange: (val) ->
            Game.updateEditingGame key: val
            .catch log.trace
        }
        helpText: 'Your game will be accessible at http://SUBDOMAIN.clay.io'
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

    Game.getEditingGame().then (game) =>
      @state.set game: game
      @state().titleBlock.input.setValue game.name
      @state().subdomainBlock.input.setValue game.key
      @state().gameIdBlock.input.setValue game.id

    Game.getEditingGame() (game) =>
      if game
        @state.set game: game

  onBeforeUnmount: =>
    @save()

  save: =>
    # images saved immediately (no need to hit 'next step')
    Game.updateById(@state().game.id, {
      name: @state().titleBlock.input.getValue()
      key: @state().subdomainBlock.input.getValue()
    })
    .then Game.updateEditingGame
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert "Error: #{error.detail}"
      throw err

  render: ({game, titleBlock, subdomainBlock, gameIdBlock}) ->
    # TODO (Austin): remove key when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z 'div.z-dev-edit-game-get-started', {key: 2},
      z 'form.form', {
        onsubmit: (e) =>
          e?.preventDefault()

          @save().then ->
            z.router.go "/developers/edit-game/details/#{game.id}"
            .catch log.trace
        },

        titleBlock
        subdomainBlock
        gameIdBlock

        z 'div.next-step-container',
          z 'button.button-secondary.next-step',
            unless Game.isStartComplete game
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
