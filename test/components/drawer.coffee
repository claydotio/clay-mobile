should = require('clay-chai').should()

Drawer = require 'components/drawer'

MockGame = require '../_models/game'

describe 'Drawer', ->

  it 'begins closed', ->
    DrawerComponent = new Drawer(MockGame)

    DrawerComponent.isOpen.should.be.false

  it 'toggles properly', ->
    DrawerComponent = new Drawer(MockGame)

    DrawerComponent.toggleOpenState()
    DrawerComponent.isOpen.should.be.true

    DrawerComponent.toggleOpenState()
    DrawerComponent.isOpen.should.be.false

  it 'closes properly', ->
    DrawerComponent = new Drawer(MockGame)
    DrawerComponent.toggleOpenState()

    DrawerComponent.close()
    DrawerComponent.isOpen.should.be.false
