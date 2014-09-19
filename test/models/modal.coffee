should = require('clay-chai').should()

Modal = require 'models/modal'
Modal.constructor() # reset

class StubComponent
  render: -> null



describe 'ModalModel', ->
  describe 'Open and Close (set and remove component)', ->
    it 'begins with null component', ->
      should.not.exist(Modal.component)

    it 'openComponent(), with component', ->
      Stub = new StubComponent()
      Modal.openComponent Stub
      Modal.component.should.be Stub

    it 'openComponent(), with null component', ->
      Modal.openComponent null
      should.not.exist(Modal.component)

    it 'closeComponent()', ->
      Stub = new StubComponent()
      Modal.openComponent Stub
      Modal.closeComponent()
      should.not.exist(Modal.component)
