_ = require 'lodash-contrib'
z = require 'zorium'
should = require('clay-chai').should()

Modal = require 'models/modal'
Modal.constructor() # reset

MockGame = require '../../_models/game'
ModalClose = require 'components/modal_close'

class StubComponent
  constructor: ->
    @ModalClose = new ModalClose()

  render: =>
    z 'div.parent-component',
      @ModalClose.render()

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.properties.className.split(' '), className

describe 'ModalClose', ->

  it 'closes modal', ->
    Stub = new StubComponent()
    Modal.openComponent {component: Stub}

    $ = Stub.render()

    $closeIcon = domWalker.find $, ($node) ->
      return hasClass $node, 'modal-close'

    $closeIcon.properties.onclick()

    should.not.exist(Modal.component)
