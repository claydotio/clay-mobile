should = require('clay-chai').should()

Modal = require 'models/modal'

class StubComponent
  render: -> null



describe 'ModalModel', ->
  describe 'Open and Close (set and remove component)', ->
    beforeEach ->
      Modal.constructor() # reset

    it 'begins with null component', ->
      should.not.exist(Modal.component)

    it 'openComponent(), with component', ->
      component = new StubComponent()
      Modal.openComponent {component}
      Modal.component.should.be component

    it 'openComponent(), with component, theme', ->
      component = new StubComponent()
      theme = '.theme-something'
      Modal.openComponent {component, theme}
      Modal.theme.should.be theme

    it 'openComponent() resets theme', ->
      component = new StubComponent()
      Modal.openComponent {component, theme: '.theme-something'}
      Modal.openComponent {component}
      should.not.exist(Modal.theme)

    it 'openComponent(), with null component', ->
      Modal.openComponent {component: null}
      should.not.exist(Modal.component)

    it 'closeComponent()', ->
      component = new StubComponent()
      Modal.openComponent {component}
      Modal.closeComponent()
      should.not.exist(Modal.component)
