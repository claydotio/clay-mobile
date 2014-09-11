_ = require 'lodash-contrib'
z = require 'zorium'
should = require('clay-chai').should()

Modal = require 'models/modal'
Modal.constructor() # reset

ModalViewer = require 'components/modal_viewer'

class StubComponent
  render: ->
    z 'div.should-exist'

domWalker = _.walk ($node) ->
  return $node.children

hasClass = ($node, className) ->
  _.contains $node.attrs.className.split(' '), className

describe 'ModalViewer', ->
  it 'renders stub modal', ->
    ModalViewerComponent = new ModalViewer()

    Stub = new StubComponent()
    Modal.openComponent Stub

    $ = ModalViewerComponent.render()

    $node = domWalker.find $, ($node) ->
      return hasClass $node, 'should-exist'

    $node.should.exist

  it 'closes', ->
    ModalViewerComponent = new ModalViewer()

    Stub = new StubComponent()
    Modal.openComponent Stub

    $ = ModalViewerComponent.render()

    $closeIcon = domWalker.find $, ($node) ->
      return hasClass $node, 'modal-close'

    $closeIcon.attrs.onclick()

    should.not.exist(Modal.component)
