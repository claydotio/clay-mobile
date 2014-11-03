should = require('clay-chai').should()
_ = require ('lodash-contrib')

Drawer = require 'components/drawer'
MockGame = require '../../_models/game'

domWalker = _.walk ($node) ->
  return $node?.children

hasClass = ($node, className) ->
  _.contains $node?.attrs.className?.split(' '), className

describe 'Drawer', ->

  it 'toggles properly', ->
    DrawerComponent = new Drawer({game: MockGame})

    # stub nub
    DrawerComponent.Nub =
      isOpen: false
      toggleOpenState: ->
        DrawerComponent.Nub.isOpen = not DrawerComponent.Nub.isOpen
      render: -> null

    DrawerComponent.Nub.toggleOpenState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'drawer'

    hasClass($drawer, 'is-open').should.be.true

    DrawerComponent.Nub.toggleOpenState()

    $ = DrawerComponent.render()
    $drawer = _.find $, ($nodeSet) ->
      domWalker.find $nodeSet, ($node) ->
        return hasClass $node, 'drawer'

    hasClass($drawer, 'is-open').should.be.false

  it 'closes properly', ->
    DrawerComponent = new Drawer(MockGame)

    # stub nub
    DrawerComponent.Nub =
      isOpen: false
      toggleOpenState: ->
        DrawerComponent.Nub.isOpen = not DrawerComponent.Nub.isOpen
      render: -> null

    DrawerComponent.Nub.toggleOpenState()
    DrawerComponent.Nub.isOpen.should.be.true

    DrawerComponent.close()
    DrawerComponent.Nub.isOpen.should.be.false
