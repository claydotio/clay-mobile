_ = require 'lodash-contrib'
z = require 'zorium'
should = require('clay-chai').should()

Modal = require 'models/modal'
Modal.constructor() # reset

MockGame = require '../../_models/game'
ModalHeader = require 'components/modal_header'

class StubComponent
  constructor: ->
    @ModalHeader = new ModalHeader(title: 'something')

  render: =>
    z 'div.parent-component',
      @ModalHeader.render()

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.properties.className.split(' '), className

describe 'ModalHeader', ->

  it 'closes modal', ->
    Stub = new StubComponent()
    Modal.openComponent {component: Stub}

    $ = Stub.render()

    $closeIcon = domWalker.find $, ($node) ->
      return hasClass $node, 'close'

    $closeIcon.properties.onclick()

    should.not.exist(Modal.component)
