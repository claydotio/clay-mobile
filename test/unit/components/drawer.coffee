should = require('clay-chai').should()
_ = require ('lodash-contrib')

Drawer = require 'components/drawer'
MockGame = require '../../_models/game'

domWalker = _.walk ($node) ->
  return $node?.children

hasClass = ($node, className) ->
  _.contains $node?.properties.className?.split(' '), className

describe 'Drawer', ->

  it 'toggles properly', ->
    DrawerComponent = new Drawer({game: MockGame})

    DrawerComponent.toggleState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'z-drawer'

    hasClass($drawer, 'is-open').should.be.true

    DrawerComponent.toggleState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'z-drawer'

    hasClass($drawer, 'is-open').should.be.false

  it 'closes properly', ->
    DrawerComponent = new Drawer(MockGame)

    DrawerComponent.toggleState()
    DrawerComponent.isOpen.should.be.true

    DrawerComponent.close()
    DrawerComponent.isOpen.should.be.false
