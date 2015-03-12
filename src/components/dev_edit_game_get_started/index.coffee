z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

Game = require '../../models/game'
InputText = require '../input_text'

styles = require './index.styl'

module.exports = class DevEditGameGetStarted
  constructor: ->
    styles.use()

    o_game = Game.getEditingGame()

    o_name = z.observe o_game.then (game) -> game.name
    o_name (val) ->
      Game.updateEditingGame name: val
    o_key = z.observe o_game.then (game) -> game.key
    o_key (val) ->
      Game.updateEditingGame key: val

    @state = z.state
      game: o_game
      nameInput: new InputText {
        label: 'Game Title'
        labelWidth: 125
        o_value: o_name
        theme: '.theme-medium-width'
      }
      keyInput: new InputText {
        label: 'Subdomain'
        labelWidth: 125
        o_value: o_key
        theme: '.theme-subdomain'
        helpText: 'Your game will be accessible at http://SUBDOMAIN.clay.io'
        postfix: '.clay.io'
        }
      gameIdInput: z.observe o_game.then (game) ->
        new InputText {
          label: 'SDK Game ID'
          labelWidth: 125
          o_value: z.observe game.id
          disabled: true
          theme: '.theme-tiny-width'
        }

  render: =>
    {game, nameInput, keyInput, gameIdInput} = @state()

    # TODO (Austin): remove key when v-dom diff/zorium unmount work properly
    # https://github.com/claydotio/zorium/issues/13
    z "div.z-dev-edit-game-get-started
    #{if Game.editingLoading is true then '.loading' else ''}", {key: 2},
      z 'form.form', {
        onsubmit: (e) ->
          e?.preventDefault()

          Game.saveEditingGame().then ->
            z.router.go "/edit-game/details/#{game.id}"
          .catch (err) ->
            log.trace err
            # TODO: (Austin) better error handling UX
            window.alert "Error: #{err.detail}"
          .catch log.trace
        },

        nameInput
        keyInput
        gameIdInput

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
